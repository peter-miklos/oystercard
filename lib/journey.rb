class Journey
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

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

  attr_reader :fare

  def calculate_fare
    if @entry_station != nil and @exit_station != nil
      @fare = MINIMUM_FARE + (@entry_station.zone - @exit_station.zone).abs
    else
      PENALTY_FARE
    end
  end
end
