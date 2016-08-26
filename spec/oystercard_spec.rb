require 'oystercard'

describe Oystercard do

  subject(:empty_card) { described_class.new }
  subject(:card) { described_class.new(journey_log) }
  let(:journey_log) {double :JourneyLog, outstanding_charges: 1, in_journey?: true, start: nil, finish: nil}
  let(:entry) { double :station }
  let(:exit) { double :station }


  describe '#top_up' do

    it 'raises an error when top up limit is exceeded' do
      maximum_limit = Oystercard::MAXIMUM_LIMIT
      empty_card.top_up(maximum_limit)
      expect{ empty_card.top_up(1) }.to raise_error 'Top up limited exceeded'
    end
  end

  describe '#touch_in' do
    before(:each) do
      card.top_up(10)
    end

    it 'raises error if balance is less than minimum required' do
      msg = "Insufficient funds. Please top up."
      expect{ empty_card.touch_in(entry) }.to raise_error msg
    end

    it 'returns true when card touched in' do
      expect(card.instance_variable_get(:@journey_log)).to receive(:start).with(entry)
      card.touch_in(entry)
    end
  end

  describe '#touch_out' do

    before(:each) do
      card.top_up(7.9)
      card.touch_in(entry)
    end

    it 'returns true when card touched out' do
      expect(card.instance_variable_get(:@journey_log)).to receive(:finish).with(exit)
      card.touch_out(exit)
    end

    it 'charges minimum fare if card is touched in and touched out' do
      card.touch_out(exit)
      expect { card.touch_in(entry) }.to raise_error (RuntimeError)
    end

  end
end
