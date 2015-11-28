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
end
