require_relative 'journey.rb'

class JourneyLog

  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @current_journey = nil
    @journey_history = []
    @outstanding_charges = 0
  end

  def start(entry_station)
    finish(nil) if in_journey?
    @current_journey = @journey_class.new(entry_station)
  end

  def finish(exit_station)
    start(nil) unless in_journey?
    @outstanding_charges = current_journey.finish(exit_station)
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
end
