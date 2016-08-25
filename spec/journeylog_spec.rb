require 'journeylog'

describe JourneyLog do

  let(:journey_log) {described_class.new}
  let(:station1) {double :station1}
  let(:station2) {double :station2}
  let(:Journey) {double :Journey}
  let(:journey1) {double :journey1}
  #let(:journey2) {double :journey2}

  before(:each) do
    allow(Journey).to receive(:new) {journey1}
    allow(journey1).to receive(:finish) {journey1}
  end

  context "#start" do

    it "creates a new journey and stores it" do
      journey_log.start(station1)
      expect(journey_log.journeys).to be_include(journey1)
    end
  end

  context "#finish" do
    it "assigns the exit station to the current journey" do
      journey_log.start(station1)
      journey_log.finish(station2)
      expect(journey_log.journeys).to be_include(journey1)
    end
  end

  context "#get_list" do
    it "returns the list of available journeys" do
      expect(journey_log.get_list).to eq journey_log.journeys
    end
  end
end
