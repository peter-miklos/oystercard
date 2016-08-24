require_relative 'journey'
require_relative 'station'

class Oystercard

  attr_reader :balance, :max_balance, :journeys, :current_journey

  DEFAULT_MAX = 90

  def initialize(balance = 0, max_balance = DEFAULT_MAX)
    @balance = balance
    @max_balance = max_balance
    @journeys = []
    @current_journey = nil
  end

  def top_up(amount)
    fail "balance cannot exceed £#{@max_balance}" if amount > max_balance - balance
    @balance += amount
  end

  def touch_in(station)
    fail "balance less than £#{Journey::MIN_FARE} - please top up" if balance < Journey::MIN_FARE
    @current_journey = Journey.new
    current_journey.start(station)
  end

  def touch_out(station)
    @current_journey = Journey.new unless current_journey
    current_journey.finish(station)
    finish_touch_out
  end

  private

  def finish_touch_out
    @journeys << current_journey
    deduct(current_journey.fare)
    @current_journey = nil
  end

  def deduct(amount)
    @balance -= amount
  end

end
