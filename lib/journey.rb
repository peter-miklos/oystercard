class Journey

  MINIMUM_CHARGE = 1
  PENALTY_CHARGE = 6

  def initialize(stations)
    @stations = stations
  end

  def finish(station)
    @stations[:exit_station] = station
    self
  end

  def complete?
    !!@stations[:entry_station] and !!@stations[:exit_station]
  end

  def fare
    return MINIMUM_CHARGE if complete?
    PENALTY_CHARGE
  end

end
