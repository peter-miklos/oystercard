require 'journey'

describe Journey do

subject(:journey) { described_class.new(station1, nil) }
subject(:journey2) { described_class.new(nil, station2) }
let(:station1) { double :station }
let(:station2) { double :station }

  describe '#finish' do

    it 'should return the current journey' do
      expect(journey.finish(station2)).to eq journey
    end

  end

  describe '#fare' do

    it 'should return the minimum fare when finished journey' do
      journey.finish(station2)
      expect(journey.fare).to eq Journey::MIN_FARE
    end

    it 'should be able to charge a penalty if no exit_station' do
      expect(journey.fare).to eq Journey::PEN_FARE
    end

    it 'should be able to charge a penalty if no entry_station' do
      expect(journey2.fare).to eq Journey::PEN_FARE
    end

  end

  describe '#complete?' do

    it'should return true if exit station exits' do
      journey.finish(station2)
      expect(journey).to be_complete
    end

    it 'should return false if no exit station' do
      expect(journey).not_to be_complete
    end

    it 'should return false if no entry station' do
      expect(journey2).not_to be_complete
    end

  end

end
