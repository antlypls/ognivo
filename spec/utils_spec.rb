require 'spec_helper'
require 'ostruct'

describe Ognivo::Utils do
  describe '.update_itemfor_file' do
    let(:file) { File.expand_path('../fixtures/app.zip', __FILE__) }
    let(:dsa_file) { File.expand_path('../fixtures/test_dsa_priv.pem', __FILE__) }
    let(:item) { OpenStruct.new }

    before(:each) { described_class.update_item_for_file(file, item, dsa_file) }

    it 'sets pub_date' do
      expect(item.pub_date).to be_a(Time)
    end

    it 'sets length' do
      expect(item.length).to eq(262350)
    end

    it 'sets dsa_signature' do
      expect(item.dsa_signature).not_to be_empty
    end

    it 'strips dsa_signature' do
      expect(item.dsa_signature[-1]).not_to eq("\n")
    end

    context 'when no dsa_file' do
      let(:dsa_file) { nil }
      it 'skips dsa signing' do
        expect(item.dsa_signature).to be_nil
      end
    end
  end
end
