class Journey

  MIN_FARE = 1
  PENALTY_FARE = 6

  attr_reader :journey

  def initialize
    @journey = {}
  end

  def start(station)
    @journey[:entry_station] = station
  end

  def finish(station)
    @journey[:exit_station] = station
  end

  def fare
    if journey.length == 2
      MIN_FARE
    else
      PENALTY_FARE
    end
  end

end
