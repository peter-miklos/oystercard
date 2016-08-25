require_relative 'station'
require_relative 'journeylog'

class Oystercard

  attr_reader :journey_log

  DEFAULT_MAX = 90

  def initialize(balance = 0, max_balance = DEFAULT_MAX)
    @balance = balance
    @max_balance = max_balance
    @journey_log = JourneyLog.new
    #@journey = nil
  end

  def top_up(amount)
    fail "balance cannot exceed £#{@max_balance}" if amount > max_balance - balance
    @balance += amount
  end

  # def in_journey?
  #   !!@journey
  # end

  def touch_in(station)
    fail "balance less than £#{Journey::MIN_FARE} - please top up" if balance < Journey::MIN_FARE
    deduct(journey_log.current_journey.fare) if journey_log.current_journey
    #deduct(@journey.fare) if in_journey?
    journey_log.start(station)

    #@journey = Journey.new(station, nil)
    #@journey_log << @journey
  end

  def touch_out(station)
    journey_log.start unless journey_log.current_journey
    deduct(journey_log.current_journey.fare)
    journey_log.finish(station)

    # if !in_journey
    #   @journey = Journey.new(nil, station)
    #   @journey_log << @journey
    # else
    #   @journey_log[-1].finish(station)
    # end
    # deduct(@journey.fare)
    #@journey = nil
  end

  private

  def deduct(amount)
    fail "Insufficient funding" if ((balance - amount) < Journey::MIN_FARE && amount == Journey::PEN_FARE)
    @balance -= amount
  end

  attr_reader :balance, :max_balance

end
