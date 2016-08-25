require 'oystercard'

describe Oystercard do

  subject(:card) {described_class.new}
  subject(:other_card) {described_class.new}

  let(:station1) {double :station1}
  let(:station2) {double :station2}
  let(:Journey) {double :Journey}
  let(:journey) {double :journey}

  let(:JourneyLog) {double :JourneyLog}
  let(:journey_log) {double :journey_log}

  before(:each) do
    card.top_up(10)
    allow(Journey).to receive(:new) {journey}
    allow(journey).to receive(:fare).and_return(1)
    allow(journey).to receive(:finish).and_return(journey)
    allow(JourneyLog).to receive(:new) {journey_log}



  end

  describe "#top_up" do

    it "adds an amount to the balance" do
      other_card.top_up(10)
      expect(card.balance).to eq 10
    end

    it "raises an error when more than the max amount is topped up" do
      top_up_amount = Oystercard::MAXIMUM_BALANCE+1
      expect{card.top_up(top_up_amount)}.to raise_error(RuntimeError)
    end
  end

  describe "#touch_in" do

    it "raises an error when try to touch in with balance less than £1" do
      amount = Oystercard::MINIMUM_BALANCE - 0.5
      other_card.top_up(amount)
      expect{other_card.touch_in(station1)}.to raise_error(RuntimeError)
    end

    it "remembers the station that was entered when touching in" do
      card.touch_in(station1)
      allow(journey).to receive(:complete?) {false}
      expect(card.journey).not_to be_complete
    end

    it "charges the penalty fare if card was not touched out" do
      card.touch_in(station1)
      final_balance = card.balance - 6
      allow(journey).to receive(:fare) {6} #penalty charge should be returned
      card.touch_in(station1)
      expect(card.balance).to eq final_balance
    end
  end

  describe "#touch_out" do
    before(:each) do
      card.touch_in(station1)
    end

    it "charges the minimum fare" do
      remaining_balance = card.balance - 1
      card.touch_out(station2)
      expect(card.balance).to eq remaining_balance
    end

    it "charges the penalty fare" do
      card.touch_out(station2)
      final_balance = card.balance - 6
      allow(journey).to receive(:fare) {6} #penalty charge should be returned
      card.touch_out(station2)
      expect(card.balance).to eq final_balance
    end

     it "sets journey instance variable to nil when touching out" do
       card.touch_out(station1)
       expect(card.journey).to be_nil
     end

    it "stores the exit station in the journey" do
      card.touch_out(station2)
      expect(card.journey_log.get_list).to be_include(journey)
    end

    it "stores the incomplete journey in the journey log" do
      card.touch_out(station2)
      card.touch_out(station1)
      expect(card.journey_log.get_list).to be_include(journey)
    end
  end
end
