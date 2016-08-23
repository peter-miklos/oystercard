require 'journey'

describe Journey do

  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:oyster)  { double :oyster }

  context 'when no entry station' do
    it 'charges a penalty fare of 6' do
      subject.finish(exit_station)
      expect(subject.fare).to eq(Journey::PENALTY_FARE)
    end
  end

  context 'when no exit station' do
    it 'charges a penalty fare of 6' do
      subject.start(entry_station)
      expect(subject.fare).to eq(Journey::PENALTY_FARE)
    end
  end

  describe 'when touched in and out' do

    before(:each) do
      subject.start(entry_station)
      subject.finish(exit_station)
    end

      it 'remembers a full journey' do
        expect(subject.journey).to include(:entry_station => entry_station, :exit_station => exit_station)
      end

      it 'should deduct minimum fare' do
        expect(subject.fare).to eq(Journey::MIN_FARE)
      end
   end
end
