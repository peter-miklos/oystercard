class JourneyLog

  PENALTY_FARE = 6 #moved to journey class should be deleted

  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @current_journey = nil
    @journey_history = []
    @outstanding_charges = 0
  end

  def start(entry_station)
    no_touch_out if in_journey?
    @current_journey = @journey_class.new(entry_station)
  end

  def finish(exit_station)
    no_touch_in unless in_journey?
    @outstanding_charges = current_journey.finish(exit_station) #1
    record_journey
    reset_journey
  end

  def in_journey?
    !!current_journey
  end

  def outstanding_charges
    x = @outstanding_charges
    @outstanding_charges = 0
    x
  end

  private

  attr_reader :current_journey, :journey_history

  def record_journey
    journey_history << current_journey
  end

  def reset_journey
    @current_journey = nil
  end

  def no_touch_out
    #@outstanding_charges += PENALTY_FARE
    finish(nil)
  end

  def no_touch_in
    start(nil)
    @outstanding_charges += PENALTY_FARE
  end

end
