require 'journey'

describe Journey do

let(:station1) { double :station1}
let(:station2) { double :station2}
let(:journey1) {described_class.new(entry_station: station1, exit_station: nil)}
let(:journey2) {described_class.new(entry_station: nil, exit_station: station2)}


  describe "#finish" do

    it "returns the journey object when exiting a journey" do
      expect(journey1.finish(station2)).to eq journey1
    end
  end

  describe "#complete?" do
    it 'returns true if the journey is complete' do
      journey1.finish(station2)
      expect(journey1).to be_complete
    end

    it 'returns false if the journey does not have an entry or exit station' do
      expect(journey1).not_to be_complete
    end
  end

  describe '#fare' do
    it 'returns the fare if journey complete' do
      journey1.finish(station2)
      expect(journey1.fare).to eq Journey::MINIMUM_CHARGE
    end

    it 'returns penalty fare if journey incomplete' do
      expect(journey1.fare).to eq Journey::PENALTY_CHARGE
    end
  end
end
