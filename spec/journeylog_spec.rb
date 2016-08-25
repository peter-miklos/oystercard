require 'journeylog'

describe JourneyLog do

  subject(:journeylog) { described_class.new }
  let(:station1) { double :station }
  let(:station2) { double :station }
  let(:Journey) { double :Journey }
  let(:journey) { double :journey }

  before(:each) do
    allow(Journey).to receive(:new) {journey}
    allow(journey).to receive(:finish).and_return(journey)
  end

  describe '#start' do

    it 'adds new journey to array of journeys' do
      journeylog.start(station1)
      expect(journeylog.journeys).to be_include(journey)
    end

  end

  describe '#finish' do

    it 'touching in and out creates one journey' do
      journeylog.start(station1)
      journeylog.finish(station2)
      expect(journeylog.journeys).to be_include(journey)
    end

  end

  describe '#journeys' do

    it 'returns the journey history' do
      journeylog.start(station1)
      expect(journeylog.journeys).to eq journeylog.journey_log
    end

  end

  describe '#in_journey?' do

    it 'after starting, in_journey? equals true' do
      journeylog.start(station1)
      expect(journeylog.in_journey?).to be(true)
    end

    it 'after finishing, in_journey? equals false' do
      journeylog.start(station1)
      journeylog.finish(station2)
      expect(journeylog.in_journey?).to be(false)
    end

  end

  it {is_expected.to respond_to(:fare)}

end
