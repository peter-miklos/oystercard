require_relative "journey.rb"

class JourneyLog

  attr_reader :current_journey, :journeys

  def initialize(journey_class: Journey)
    @journeys = []
    @journey_class = journey_class
  end

  def start(station = nil)
    @current_journey = journey(station)
    @journeys << current_journey
    current_journey
  end

  def finish(station)
    @journeys[-1].finish(station)
    @current_journey = nil
  end

  def current_journey_exists?
    !!current_journey
  end

  def get_list
    @journeys.clone
  end

  private

  attr_reader :journey_class

  def journey(station)
    journey_class.new(entry_station: station)
  end

  def current_journey
    @current_journey || journey_class.new
  end

end
