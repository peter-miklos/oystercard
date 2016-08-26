require 'journey'

describe Journey do


  subject { described_class.new(station_3) }
  let(:station_6) { double :station, zone: 6 }
  let(:station_3) { double :station, zone: 3 }
  let(:station_1) { double :station, zone: 1}


  describe "#initialize" do
    it 'records the entry station' do
      expect(subject.instance_variable_get(:@entry_station)).to eq station_3
    end
  end


  describe "#finish" do
    it 'records the exit station' do
      subject.finish(station_1)
      expect(subject.instance_variable_get(:@exit_station)).to eq station_1
    end

    it "returns the penalty fare if there is no entry station" do
      journey2 = described_class.new(nil)
      expect(journey2.finish(station_1)).to eq Journey::PENALTY_FARE
    end

    it "returns a penalty fare if there is no exit station" do
      expect(subject.finish(nil)).to eq Journey::PENALTY_FARE
    end
    
    it 'calculates correct fare' do
      subject.finish(station_1)
      expect(subject.fare).to eq 3
    end
    it 'calculates correct fare' do
      subject.finish(station_3)
      expect(subject.fare).to eq 1
    end
    it 'calculates correct fare' do
      subject.finish(station_6)
      expect(subject.fare).to eq 4
    end


  end









end
