require 'spec_helper'

describe Ognivo::Agvtool do
  describe '.marketing_version' do
    let(:output) { "\"MegaApp.xcodeproj/../App/MegaApp-Info.plist\"=1.2.3\n" }

    subject { described_class.marketing_version }

    it 'projects version' do
      expect(described_class)
        .to receive(:`)
        .with('agvtool what-marketing-version -terse') { output }

      expect(subject).to eq('1.2.3')
    end
  end
end
