require 'oystercard'

describe Oystercard do

  subject(:oyster) { described_class.new }

  let(:station) { double :station }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:Journey) { double :Journey }
  let(:journey) { double :journey }

  before(:each) do
    allow(Journey).to receive(:new).and_return(journey)
    allow(journey).to receive(:fare) { 1 }
    allow(journey).to receive(:finish).and_return(journey)
  end

  it 'initializes with a balance of 0' do
    expect(oyster.balance).to eq(0)
  end

  describe '#top_up' do

    it 'increases balance by amount' do
      oyster.top_up(10)
      expect(oyster.balance).to eq 10
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

      subject(:oyster) { described_class.new(10)}

      before(:each) do
        oyster.touch_in(entry_station)
      end

      it 'after touching in, in_journey equals true' do
        expect(oyster.in_journey?).to be(true)
      end

      it 'adds new journey to array of journeys' do
        expect(oyster.journey_log).to be_include(journey)
      end

      it 'deducts penalty fare for incomplete journey' do
        allow(journey).to receive(:fare) { 6 }
        expect {oyster.touch_in(station)}.to change{oyster.balance}.by(-6)
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
      oyster.top_up(10)
      oyster.touch_in(station)
    end

    it 'after touching out, in_journey equals false' do
      oyster.touch_out(station)
      expect(oyster.in_journey?).to be(false)
    end

    it 'deducts minimum fare as calculated in journey class' do
      expect {oyster.touch_out(station)}.to change{oyster.balance}.by(-1)
    end

    it 'deducts a penalty fare as calculated in journey class' do
      allow(journey).to receive(:fare).and_return(6)
      oyster.touch_out(station)
      expect {oyster.touch_out(station)}.to change{oyster.balance}.by(-6)
    end

  end

  describe 'store journey' do

    it 'touching in and out creates one journey' do
      oyster.top_up(10)
      oyster.touch_in(entry_station)
      oyster.touch_out(exit_station)
      expect(oyster.journey_log).to be_include(journey)
    end

  end
end
