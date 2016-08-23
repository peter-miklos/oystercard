require 'oystercard'

describe Oystercard do

  subject(:card) {described_class.new}
  subject(:other_card) {described_class.new}

  let(:station1) {double :station1}
  let(:station2) {double :station2}
  let(:Journey) {double :Journey}
  let(:journey) {double :journey}

  before(:each) do
    card.top_up(10)
    allow(Journey).to receive(:new) {journey}
    allow(journey).to receive(:fare).and_return(1)
    allow(journey).to receive(:finish).and_return(journey)
  end

  describe "initialize" do
    it "creates an instance of the card and the balance should be zero" do
      expect(other_card.balance).to eq 0
    end

    it "creates an in_journey instance variable with default of false" do
      expect(card.in_journey?).to eq false
    end

    it "creates an empty array of stations" do
      expect(card.journeys).to be_empty
    end

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

  describe "#in_journey?" do

    it "returns false if we call it after instantiated the instance" do
      expect(card).not_to be_in_journey
    end

    it "returns true after touch in" do
      card.touch_in(station1)
      expect(card).to be_in_journey
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
      expect(card.entry_station).to eq station1
    end

    it "charges the penalty fare if card was not touched out" do
      card.touch_in(station1)
      final_balance = card.balance - 6
      allow(journey).to receive(:fare) {6} #penalty charge should be returned
      card.touch_in(station1)
      expect(card.balance).to eq final_balance
    end

    it "stores an incomplete journey in journey log" do
      card.touch_in(station1)
      expect(card.journeys).to be_include(journey)
    end
  end

  describe "#touch_out" do
    before(:each) do
      card.touch_in(station1)
    end

    it "called, then the #in_journey? method returns false" do
      card.touch_out(station1)
      expect(card).not_to be_in_journey
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

    it "sets entry_station ivar to nil when touching out" do
      card.touch_out(station1)
      expect(card.entry_station).to eq nil
    end

    it "stores the exit station in the journey, stored in the journey log" do
      card.touch_out(station2)
      expect(card.journeys).to be_include(journey)
    end

    it "stores the incomplete journey in the journey log" do
      card.touch_out(station2)
      card.touch_out(station1)
      expect(card.journeys).to be_include(journey)
    end
  end
end
