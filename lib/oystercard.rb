require_relative "journey.rb"
require_relative "station.rb"

class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  attr_reader :balance, :journey, :journey_log

  def initialize
   @balance = 0
   #@journeys = []
   @journey = nil
   @journey_log = JourneyLog.new
  end

  def top_up(amount)
    fail "Can't add more than £#{MAXIMUM_BALANCE}" if balance + amount >  MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(station)
    fail "Your balance is less than £1" if below_limit?
    finish_journey if journey_log.current_journey_exists? #ezt megnezni irb-ben
    @journey = journey_log.start(station)
  end

  def touch_out(station)
    @journey = journey_log.start unless journey_log.current_journey_exists?
    journey_log.finish(station)
    finish_journey
  end

  private

  def below_limit?
    balance < MINIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

  def finish_journey
    #@journeys << @journey
    deduct(journey_log.get_list[-1].fare)
    @journey = nil
  end
end
