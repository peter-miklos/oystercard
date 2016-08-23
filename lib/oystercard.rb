class Oystercard

  attr_reader :balance, :max_balance, :journeys

  DEFAULT_MAX = 90
  MIN_FARE = 1

  def initialize(balance = 0, max_balance = DEFAULT_MAX)
    @balance = balance
    @max_balance = max_balance
    @journeys = []
  end

  def top_up(amount)
    fail "balance cannot exceed £#{@max_balance}" if amount > max_balance - balance
    @balance += amount
  end

  def touch_in(station)
    fail "balance less than £#{MIN_FARE} - please top up" if balance < MIN_FARE
    @journeys << { :entry_station => station, :exit_station => nil }
  end

  def touch_out(station)
    deduct(MIN_FARE)
    @journeys[-1][:exit_station] = station
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
