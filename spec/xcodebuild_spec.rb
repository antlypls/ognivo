require 'spec_helper'

describe Ognivo::XcodeBuild do
  let(:output) { File.read(file) }

  context 'with settings output' do
    let(:file) { File.expand_path('../fixtures/xcodebuild-settings-output.txt', __FILE__) }

    describe '.parse_settings_output' do
      subject { described_class.parse_settings_output(output) }

      it 'parses' do
        expect(subject.keys).to match_array(%w(MegaProject))

        expect(subject['MegaProject'])
          .to include('WRAPPER_NAME' => 'MegaProject.app')

        expect(subject['MegaProject'])
          .to include('CONFIGURATION' => 'Release')

        expect(subject['MegaProject'])
          .to include('BUILT_PRODUCTS_DIR' => '/Users/user/Library/Developer/Xcode/DerivedData/MegaProject-hnpshjktfnkgedbfccsjjlyytcgy/Build/Products/Release')

        expect(subject['MegaProject'])
          .to include('WRAPPER_EXTENSION' => 'app')
      end
    end

    describe '.settings' do
      before(:example) do
        expect(described_class)
          .to receive(:`)
          .with('xcodebuild -workspace "MegaProject.xcworkspace" -scheme "MegaProject" -configuration "Release" -showBuildSettings 2> /dev/null')
          .and_return(output)
      end

      let(:flags) do
        [
          '-workspace "MegaProject.xcworkspace"',
          '-scheme "MegaProject"',
          '-configuration "Release"'
        ]
      end

      subject { described_class.settings(*flags) }

      it 'returns settings' do
        expect(subject).to be_an(Ognivo::XcodeBuild::Settings)
      end

      it 'is querable' do
        _, xcodebuild_settings = subject.find { |_, settings| settings['WRAPPER_EXTENSION'] == 'app' }

        expect(xcodebuild_settings['CONFIGURATION']).to eq('Release')
        expect(xcodebuild_settings['BUILT_PRODUCTS_DIR']).to eq('/Users/user/Library/Developer/Xcode/DerivedData/MegaProject-hnpshjktfnkgedbfccsjjlyytcgy/Build/Products/Release')
        expect(xcodebuild_settings['WRAPPER_NAME']).to eq('MegaProject.app')
        expect(xcodebuild_settings['WRAPPER_EXTENSION']).to eq('app')
      end

      describe '.find_app' do
        subject { described_class.settings(*flags).find_app }

        it 'returns correct app' do
          expect(subject['CONFIGURATION']).to eq('Release')
          expect(subject['BUILT_PRODUCTS_DIR']).to eq('/Users/user/Library/Developer/Xcode/DerivedData/MegaProject-hnpshjktfnkgedbfccsjjlyytcgy/Build/Products/Release')
          expect(subject['WRAPPER_NAME']).to eq('MegaProject.app')
          expect(subject['WRAPPER_EXTENSION']).to eq('app')
        end
      end
    end
  end

  context 'with info output' do
    let(:file) { File.expand_path('../fixtures/xcodebuild-info-output.txt', __FILE__) }

    describe '.parse_info_output' do
      subject { described_class.parse_info_output(output) }

      it 'returns parsed info' do
        expected = {
          :project => 'MegaProject',
          'targets' => ['MegaProject'],
          'build_configurations' => %w(Debug Release),
          'schemes' => ['MegaProject']
        }

        expect(subject).to eq(expected)
      end
    end

    describe '.info' do
      before(:example) do
        expect(described_class)
          .to receive(:`)
          .with('xcodebuild -list  2>&1')
          .and_return(output)
      end

      subject { described_class.info(workspace: nil) }

      it 'returns info object' do
        expect(subject).to be_an(Ognivo::XcodeBuild::Info)
      end

      it 'returns correct info' do
        expect(subject.schemes).to eq(%w(MegaProject))
        expect(subject.targets).to eq(%w(MegaProject))
        expect(subject.build_configurations).to match_array(%w(Debug Release))
        expect(subject.project).to eq('MegaProject')
      end
    end
  end

  describe '.parse_xcode_version' do
    let(:output) { "Xcode 5.1.1\nBuild version 5B1008\n" }

    subject { described_class.parse_xcode_version(output) }

    it 'returns xcode version' do
      expect(subject).to eq('5.1.1')
    end
  end
end
