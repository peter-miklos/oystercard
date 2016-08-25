class Journey

  MIN_FARE = 1
  PEN_FARE = 6

  def initialize(entry_station, exit_station)
    @entry_station = entry_station
    @exit_station = exit_station
  end

  def finish(station)
    @exit_station = station
    self
  end

  def complete?
    !!@entry_station && !!@exit_station
  end

  def fare
    complete? ? MIN_FARE : PEN_FARE
  end

  private

  attr_reader :entry_station, :exit_station

end
