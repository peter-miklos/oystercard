class Journey

  attr_reader :journey

  def initialize
    @journey = { entry_station: '', exit_station: '' }
  end

  def start(station)
    @journey[:entry_station] = station
  end

  def finish(station)
    @journey[:exit_station] = station
  end

end
