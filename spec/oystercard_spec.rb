require 'oystercard'

describe Oystercard do

  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }

  context do 'when initialized'
    it 'has a balance of 0' do
      expect(subject.balance).to eq(0)
    end

    it 'has an empty list of journeys' do
      expect(subject.journeys).to be_empty
    end
  end

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

  end

  describe '#touch_out' do

    before(:each) do
      subject.top_up(10)
      subject.touch_in(entry_station)
    end

    it 'deducts minimum fare from oyster' do
      expect {subject.touch_out(exit_station)}.to change{subject.balance}.by(-Oystercard::MIN_FARE)
    end

  end

  it 'remembers a full journey' do
    subject.top_up(10)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject.journeys).to include(:entry_station => entry_station, :exit_station => exit_station)
  end

end
