class Journey

  MINIMUM_CHARGE = 1
  PENALTY_CHARGE = 6

  def initialize(entry_station: nil, exit_station: nil)
    @entry_station = entry_station
    @exit_station = exit_station
  end

  def finish(station)
    @exit_station = station
    self
  end

  def complete?
    !!entry_station and !!exit_station
  end

  def fare
    complete? ? MINIMUM_CHARGE : PENALTY_CHARGE
  end

  private
  attr_reader :entry_station, :exit_station

end
