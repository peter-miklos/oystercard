require_relative "journey.rb"
require_relative "station.rb"

class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_CHARGE = 1

  attr_reader :balance, :journeys, :journey

  def initialize
   @balance = 0
   @journeys = []
   @journey = nil
  end

  def top_up(amount)
    fail "Can't add more than £#{MAXIMUM_BALANCE}" if balance + amount >  MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(station)
    fail "Your balance is less than £1" if below_limit?
    validate_touch_in(station)
  end

  def touch_out(station)
    validate_touch_out(station)
    deduct(@journey.fare)
    @journey = nil
  end

  private
  def below_limit?
    balance < MINIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

  def store_journey
    @journeys << @journey
  end

  def validate_touch_in(station)
    if @journey
      store_journey
      deduct(@journey.fare)
    else
      @journey = Journey.new(entry_station: station)
    end
  end

  def validate_touch_out(station)
    if @journey
      @journey.finish(station)
      store_journey
    else
      @journey = Journey.new(exit_station: station)
      store_journey
    end
  end
end
