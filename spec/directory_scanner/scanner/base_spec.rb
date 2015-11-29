require 'rails_helper'

describe DirectoryScanner::Scanner::Base do
  describe '#search_business_local' do
    let(:scanners_path) {
      File.join(Rails.root, 'config', 'scanners')
    }
    let(:instance) {
      DirectoryScanner::Scanner::Base.new configuration_path, directory
    }
    subject do
      instance.search_business_local business_local
    end
    let(:business_local) {
      BusinessLocal.new(name: 'Encore India', city: 'Simi Valley', state: 'CA')
    }
    let(:configuration_path) {
      File.join(scanners_path, "#{directory.name}.yml")
    }
    context 'with yahoo' do
      let(:directory) { DirectoryScanner::Directory.new(name: 'yahoo') }
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
      let(:directory) { DirectoryScanner::Directory.new(name: 'foursquare') }
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
      let(:directory) { DirectoryScanner::Directory.new(name: 'yelp') }
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
      let(:directory) { DirectoryScanner::Directory.new(name: 'white_pages') }
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
      let(:directory) { DirectoryScanner::Directory.new(name: 'switch_board') }
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
      let(:directory) { DirectoryScanner::Directory.new(name: '411') }
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
      let(:directory) { DirectoryScanner::Directory.new(name: 'map_quest') }
      it 'brings back correct result' do
        expect(subject).not_to be_blank
        expect(subject.name).to eq 'Encore India'
        expect(subject.full_address)
          .to eq '5924 E Los Angeles Ave , Simi Valley, CA 93063'
        expect(subject.url)
          .to eq 'http://www.mapquest.com/us/california/business-simi-valley/encore-india-345867169'
      end
    end
    context 'with super_pages' do
      let(:business_local) {
        BusinessLocal.new(name: 'Encore India',
          address: '5924 East Los Angeles Ave', city: 'Simi Valley',
          state: 'CA')
      }
      let(:directory) { DirectoryScanner::Directory.new(name: 'super_pages') }
      it 'brings back correct result' do
        expect(subject).not_to be_blank
        expect(subject.name).to eq 'Encore India'
        expect(subject.full_address.gsub("\n"," "))
          .to eq '5924 E Los Angeles Ave,  Simi Valley, CA 93063  93063'
        expect(subject.url)
          .to eq 'http://www.superpages.com/bp/Simi-Valley-CA/Encore-India-L2584373262.htm'
      end
    end
    context 'with city_search' do
      let(:directory) { DirectoryScanner::Directory.new(name: 'city_search') }
      it 'brings back correct result' do
        expect(subject).not_to be_blank
        expect(subject.name).to eq 'Encore India'
        expect(subject.full_address.gsub(/(\n|\r)/,""))
          .to eq '5924 E Los Angeles Ave, Simi Valley, CA'
        expect(subject.url)
          .to match 'http://www.citysearch.com/profile/626279594/simi_valley_ca/encore_india.html'
      end
    end
    context 'with local' do
      # TODO: Customization
      let(:directory) { DirectoryScanner::Directory.new(name: 'local') }
      let(:business_local) {
        BusinessLocal.new(name: 'Encore Repair Services',
          city: 'Simi Valley', state: 'CA')
      }
      it 'brings back correct result' do
        expect(subject).not_to be_blank
        expect(subject.name).to eq 'Encore Repair Services'
        expect(subject.full_address.gsub(/(\n|\r)/,""))
          .to eq '5924 E Los Angeles Ave, Simi Valley, CA'
        expect(subject.url)
          .to match 'http://www.citysearch.com/profile/626279594/simi_valley_ca/encore_india.html'
      end
    end
    context 'with dex_knows' do
      # TODO: Customization
      let(:directory) { DirectoryScanner::Directory.new(name: 'dex_knows') }
      let(:business_local) {
        BusinessLocal.new(name: 'Walmart', city: 'Simi Valley', state: 'CA')
      }
      it 'brings back correct result' do
        expect(subject).not_to be_blank
        expect(subject.name).to eq 'Walmart'
        expect(subject.address.gsub(/(\n)/,""))
          .to eq '255 Cochran St,'
        expect(subject.phone_number).to eq '(805) 581-1666'
        expect(subject.url)
          .to match 'http://www.dexknows.com/business_profiles/walmart_simi_valley-l901718860'
      end
    end

  end
end
