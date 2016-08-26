require_relative 'journey_log'
require_relative 'Station.rb'

class Oystercard
  MINIMUM_BALANCE = 7
  MAXIMUM_LIMIT = 90



  def initialize(journey_log = JourneyLog.new)
    @balance = 0
    @journey_log = journey_log
  end

  def touch_in(station_name)
    fail "Insufficient funds. Please top up." if @balance < MINIMUM_BALANCE
    start_journey(station_name)
    deduct(@journey_log.outstanding_charges)
  end


  def touch_out(station)
    finish_journey(station)
    deduct(@journey_log.outstanding_charges)
  end

  def top_up(amount)
    fail 'Top up limited exceeded' if amount + @balance > MAXIMUM_LIMIT
    @balance += amount
  end

  private

    attr_reader :balance

  def start_journey(station)
    @journey_log.start(station)
  end

  def finish_journey(station)
    @journey_log.finish(station)
  end

  def deduct(amount)
    @balance -= amount
  end

end
