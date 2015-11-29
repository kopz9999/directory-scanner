require 'rails_helper'

RSpec.describe Api::DirectoriesController, type: :controller do
  describe '#search' do
    let(:output_json) { response_json }
    let(:directory_key) { 'yahoo' }
    let(:search_params) {
      {
        business_local: {
          name: 'Encore India',
          city: 'Simi Valley',
          state: 'CA'
        },
        directory_key: directory_key
      }
    }
    subject do
      post :search, search_params
    end
    it 'brings back results' do
      subject
      expect( response ).to be_success
      expect( output_json[:name] ).to eq 'Encore India'
      expect( output_json[:full_address] )
        .to eq '5924 E Los Angeles Ave, Simi Valley, CA 93063'
    end
    context 'with not found' do
      let(:search_params) {
        {
          business_local: {
            name: 'This is not a business',
          },
          directory_key: directory_key
        }
      }
      it 'is not found' do
        subject
        expect( response.body ).to be_blank
        expect( response.status ).to eq 404
      end
    end
    context 'with error' do
      let(:search_params) {
        {
          business_local: {
            name: 'This is not a business',
          },
          directory_key: 'unknown'
        }
      }
      it 'is not found' do
        subject
        expect( response.status ).to eq 422
      end
    end
  end
end
