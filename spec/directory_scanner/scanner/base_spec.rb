require 'rails_helper'

describe DirectoryScanner::Scanner::Base do
  describe '#search_directory' do
    let(:scanners_path) {
      File.join(Rails.root, 'config', 'scanners')
    }
    let(:instance) {
      DirectoryScanner::Scanner::Base.new configuration_path
    }
    subject do
      instance.search_directory directoy
    end
    let(:directoy) {
      Directory.new(name: 'Encore India', address: 'Simi Valley, CA')
    }
    context 'with yahoo' do
      let(:configuration_path) { File.join(scanners_path, 'yahoo.yml') }
      it 'brings back correct result' do
        expect(subject.name).to eq 'Encore India'
        expect(subject.address)
          .to eq '5924 E Los Angeles Ave, Simi Valley, CA 93063'
        expect(subject.phone_number).to eq '(805) 624-5513'
        expect(subject.url)
          .to eq 'https://local.yahoo.com/info-168934858-encore-india-simi-valley'
      end
    end
  end
end
