require 'oystercard'

describe Oystercard do

  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:Journey) {double :Journey}
  let(:current_journey) {double :current_journey}


  before(:each) do
    allow(Journey).to receive(:new) {current_journey}
    allow(current_journey).to receive(:start) { nil }
    allow(current_journey).to receive(:finish) { nil }
    allow(current_journey).to receive(:fare) { 1 }
  end

=begin
  context 'when initialized' do
    it 'has a balance of 0' do
      expect(subject.balance).to eq(0)
    end

    it 'has an empty list of journeys' do
      expect(subject.journeys).to be_empty
    end
=end

  describe '#top_up' do
    it 'increases balance by amount' do
      subject.top_up(10)
      expect(subject.balance).to eq 10
    end

    context 'balance is greater than max limit' do
      it 'raises an error' do
        message = "balance cannot exceed £#{Oystercard::DEFAULT_MAX}"
        expect{subject.top_up(Oystercard::DEFAULT_MAX+10)}.to raise_error message
      end
    end
  end

  describe '#touch_in' do
    context 'balance is less than min balance' do
      it 'raises an error' do
        message = 'balance less than £1 - please top up'
        expect{subject.touch_in(entry_station)}.to raise_error message
      end
    end

    it 'creates a new journey' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect(subject.current_journey).to eq(current_journey)
    end

  end

  describe '#touch_out' do
    before(:each) do
      subject.top_up(10)
    end

    it 'current journey should be nil' do
      subject.touch_out(exit_station)
      expect(subject.current_journey).to eq nil
    end

    context 'when not touched in' do
      it 'incomplete journey should be stored in journeys' do
        allow(current_journey).to receive(:finish)
        subject.touch_out(exit_station)
        expect(subject.journeys).to be_include(current_journey)
      end

    end

    context 'when touched in' do
      before(:each) do
        subject.touch_in(entry_station)
      end
      it 'deducts minimum fare from oyster' do
        expect {subject.touch_out(exit_station)}.to change{subject.balance}.by(-1)
      end

      it 'remembers a full journey' do
        subject.touch_out(exit_station)
        expect(subject.journeys).to be_include(current_journey)
      end
    end
  end

end
