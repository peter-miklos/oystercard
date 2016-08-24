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

# why is fare returning 6 when called explicitly after a full journey in irb?
# will be an issue if want to check our last fare
  def fare
    journey.length == 2 ? MIN_FARE : PENALTY_FARE
  end

end
