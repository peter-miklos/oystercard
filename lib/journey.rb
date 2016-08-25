# station of entry
# station of exit

# fare - how much journey costs

class Journey
  MINIMUM_FARE = 1

attr_reader :fare

  def initialize(entry_station)
    @entry_station = entry_station
    @exit_station = nil
    @fare = MINIMUM_FARE
  end

  def finish(exit_station)
    @exit_station = exit_station
    calculate_fare
  end

  private

  def calculate_fare
    @fare = MINIMUM_FARE + (@entry_station.zone - @exit_station.zone).abs
  end
end
