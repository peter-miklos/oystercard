require_relative 'station'
require_relative 'journeylog'
require_relative "journey"

class Oystercard

  attr_reader :journey_log

  DEFAULT_MAX = 90

  def initialize(balance = 0, max_balance = DEFAULT_MAX)
    @balance = balance
    @max_balance = max_balance
    @journey_log = JourneyLog.new
  end

  def top_up(amount)
    fail "balance cannot exceed £#{@max_balance}" if amount > max_balance - balance
    @balance += amount
  end

  def touch_in(station)
    fail "balance less than £#{Journey::MIN_FARE} - please top up" if balance < Journey::MIN_FARE
    deduct(journey_log.start(station))
  end

  def touch_out(station)
    deduct(journey_log.finish(station))
  end

  private

  def deduct(amount)
    fail "Insufficient funding" if ((balance - amount) < Journey::MIN_FARE && amount == Journey::PEN_FARE)
    @balance -= amount
  end

  attr_reader :balance, :max_balance

end
