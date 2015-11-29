require 'rails_helper'

describe DirectoryScanner::Manager do
  let(:instance) { described_class.instance }
  describe '#initialize' do
    it 'loads directories' do
      expect(instance.directories).to be_kind_of(Array)
      expect(instance.directories).not_to be_blank
      expect(instance.directories.first.name).to eq 'yahoo'
      expect(instance.directories.first.display).to eq 'Yahoo'
    end
  end
  describe '#search' do
    let(:business_local) {
      BusinessLocal.new(name: 'Encore India', city: 'Simi Valley', state: 'CA')
    }
    subject do
      instance.search business_local, scanner_key
    end
    context 'with valid scanner_key' do
      let(:scanner_key) { :yahoo }
      it 'performs search' do
        expect_any_instance_of(DirectoryScanner::Scanner::Base)
          .to receive(:search_business_local)
        subject
      end
    end
    context 'with unknown scanner_key' do
      let(:scanner_key) { :unknown }
      it 'raises error' do
        expect_any_instance_of(DirectoryScanner::Scanner::Base)
          .not_to receive(:search_business_local)
        expect { subject }.to \
          raise_error(DirectoryScanner::Manager::UnknownDirectory)
      end
    end
    context 'with inactive scanner_key' do
      let(:scanner_key) { :inactive }
      before do
        instance.directories <<
          DirectoryScanner::Directory.new(name: 'inactive', active: false)
      end
      it 'raises error' do
        expect_any_instance_of(DirectoryScanner::Scanner::Base)
          .not_to receive(:search_business_local)
        expect { subject }.to \
          raise_error(DirectoryScanner::Manager::InactiveDirectory)
      end
    end
    context 'with invalid scanner_key' do
      let(:scanner_key) { :invalid }
      before do
        instance.directories <<
          DirectoryScanner::Directory.new(name: 'invalid', active: true)
      end
      it 'raises error' do
        expect_any_instance_of(DirectoryScanner::Scanner::Base)
          .not_to receive(:search_business_local)
        expect { subject }.to \
          raise_error(DirectoryScanner::Manager::InvalidDirectory)
      end
    end
  end
end
