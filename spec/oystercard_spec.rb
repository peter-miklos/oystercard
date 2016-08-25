require 'oystercard'

describe Oystercard do

  subject(:oyster) { described_class.new }

  let(:station) { double :station }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:JourneyLog) { double :JourneyLog }
  let(:journeylog) { double :journeylog }

  before(:each) do
    allow(JourneyLog).to receive(:new).and_return(journeylog)
    allow(journeylog).to receive(:finish) {1}
    allow(journeylog).to receive(:start) {0}
  end

  describe '#top_up' do

    it 'increases balance by amount' do
      oyster.top_up(0.9)
      expect{oyster.touch_in(entry_station)}.to raise_error(RuntimeError)
    end

    context 'balance is greater than max limit' do

      it 'raises an error' do
        message = "balance cannot exceed £#{Oystercard::DEFAULT_MAX}"
        expect{oyster.top_up(Oystercard::DEFAULT_MAX+10)}.to raise_error message
      end

    end

  end

  describe '#touch_in' do

    context 'balance is greater than min balance' do

      subject(:oyster) { described_class.new(6)}

      before(:each) do
        oyster.touch_in(entry_station)
      end

      it 'deducts penalty fare for incomplete journey' do
        allow(journeylog).to receive(:start) {6}
        expect{oyster.touch_in(entry_station)}.to raise_error(RuntimeError)
      end

    end

    context 'balance is less than min balance' do

      it 'raises an error' do
        message = 'balance less than £1 - please top up'
        expect{oyster.touch_in(station)}.to raise_error message
      end

    end

  end

  describe '#touch_out' do

    before(:each) do
      oyster.top_up(1.9)
      oyster.touch_in(station)
    end

    it 'deducts minimum fare as calculated in journey class' do
      oyster.touch_out(exit_station)
      expect{oyster.touch_in(entry_station)}.to raise_error(RuntimeError)
    end

    it 'deducts a penalty fare as calculated in journey class' do
      oyster.top_up(6)
      oyster.touch_out(station)
      allow(journeylog).to receive(:finish) {6}
      expect{oyster.touch_out(exit_station)}.to raise_error(RuntimeError)
    end

  end

end
