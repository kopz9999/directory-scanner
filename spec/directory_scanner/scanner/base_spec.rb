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
      instance.search_business_local business_local
    end
    let(:business_local) {
      BusinessLocal.new(name: 'Encore India', city: 'Simi Valley', state: 'CA')
    }
    context 'with yahoo' do
      let(:configuration_path) { File.join(scanners_path, 'yahoo.yml') }
      it 'brings back correct result' do
        expect(subject).not_to be_blank
        expect(subject.name).to eq 'Encore India'
        expect(subject.full_address)
          .to eq '5924 E Los Angeles Ave, Simi Valley, CA 93063'
        expect(subject.phone_number).to eq '(805) 624-5513'
        expect(subject.url)
          .to eq 'https://local.yahoo.com/info-168934858-encore-india-simi-valley'
      end
    end
    context 'with foursquare' do
      let(:business_local) {
        BusinessLocal.new(name: 'Encore India',
          address: '5924 E Los Angeles Ave', city: 'Simi Valley', state: 'CA')
      }
      let(:configuration_path) { File.join(scanners_path, 'foursquare.yml') }
      it 'brings back correct result' do
        expect(subject).not_to be_blank
        expect(subject.name).to eq 'Encore India'
        expect(subject.address)
          .to eq '5924 E Los Angeles Ave'
        expect(subject.url)
          .to eq 'https://foursquare.com/v/encore-india/50ee59a372dafbd6c7afc20a'
      end
    end
    context 'with yelp' do
      let(:configuration_path) { File.join(scanners_path, 'yelp.yml') }
      it 'brings back correct result' do
        expect(subject).not_to be_blank
        expect(subject.name).to eq 'Encore India'
        expect(subject.full_address)
          .to eq '5924 E Los Angeles Ave, Simi Valley, CA 93063'
        expect(subject.phone_number).to eq '(805) 624-5513'
        expect(subject.url)
          .to eq 'http://www.yelp.com/biz/encore-india-simi-valley'
      end
    end
    context 'with white_pages' do
      let(:configuration_path) { File.join(scanners_path, 'white_pages.yml') }
      it 'brings back correct result' do
        expect(subject).not_to be_blank
        expect(subject.name).to eq 'Encore India'
        expect(subject.address)
          .to eq '5924 E Los Angeles Ave, Simi Valley, CA 93063'
        expect(subject.url)
          .to eq 'http://www.whitepages.com/business/encore-india-simi-valley-ca'
      end
    end
    context 'with switch_board' do
      let(:configuration_path) { File.join(scanners_path, 'switch_board.yml') }
      it 'brings back correct result' do
        expect(subject).not_to be_blank
        expect(subject.name).to eq 'Encore India'
        expect(subject.address)
          .to eq '5924 E Los Angeles Ave, Simi Valley, CA 93063'
        expect(subject.url)
          .to eq 'http://www.switchboard.com/business/encore-india-simi-valley-ca'
      end
    end
    context 'with 411' do
      let(:configuration_path) { File.join(scanners_path, '411.yml') }
      it 'brings back correct result' do
        expect(subject).not_to be_blank
        expect(subject.name).to eq 'Encore India'
        expect(subject.address)
          .to eq '5924 E Los Angeles Ave, Simi Valley, CA 93063'
        expect(subject.url)
          .to eq 'http://www.switchboard.com/business/encore-india-simi-valley-ca'
      end
    end
    context 'with map_quest' do
      let(:configuration_path) { File.join(scanners_path, 'map_quest.yml') }
      it 'brings back correct result' do
        expect(subject).not_to be_blank
        expect(subject.name).to eq 'Encore India'
        expect(subject.full_address)
          .to eq '5924 E Los Angeles Ave , Simi Valley, CA 93063'
        expect(subject.url)
          .to eq 'http://www.mapquest.com/us/california/business-simi-valley/encore-india-345867169'
      end
    end

  end
end
