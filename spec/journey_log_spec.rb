require 'journey_log'

describe JourneyLog do
  subject(:journey_log) {described_class.new(journey_class)}
  let(:journey_class) {double(:journey_class, new: journey)}
  let(:journey) {double(:journey, finish: nil)}
  let(:entry_station) {double(:entry_station)}
  let(:exit_station) {double(:exit_station)}

  describe 'initialization' do
    it 'saves the journey class to an instance variable' do
      expect(journey_log.instance_variable_get(:@journey_class)).to eq journey_class
    end
    it 'does not have a current journey saved' do
      expect(journey_log.instance_variable_get(:@current_journey)).to be_nil
    end
    describe 'in_journey?' do
      it 'Is in journey' do
        expect(journey_log.in_journey?).to be false
      end
    end
  end

  describe 'start' do
    before do
      journey_log.start(entry_station)
    end
    it 'instantiates the journey class' do
      expect(journey_class).to have_received(:new).with entry_station
    end
    it 'saves the current journey' do
      expect(journey_log.instance_variable_get(:@current_journey)).to eq journey
    end

    describe 'in_journey?' do
      it 'Is in journey' do
        expect(journey_log.in_journey?).to be true
      end
    end
  end

  describe 'finish' do
    before do
      journey_log.start(entry_station)
      journey_log.finish(exit_station)
    end
    it 'passes exit station to journey instance' do
      expect(journey).to have_received(:finish).with exit_station
    end

    it 'is recorded to journey history' do
      expect(journey_log.instance_variable_get(:@journey_history)).to eq [journey]
    end

    it 'resets current_journey' do
      expect(journey_log.instance_variable_get(:@current_journey)).to be_nil
    end

    describe 'in_journey?' do
      it 'Is in journey' do
        expect(journey_log.in_journey?).to be false
      end
    end

  end

end
