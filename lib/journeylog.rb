class JourneyLog

  attr_reader :current_journey, :journey_log

  def initialize(journey_class: Journey)
    @journey_log = []
    @journey_class = journey_class
  end


  def start(station = nil)
    #current_journey(station)
    @current_journey = journey(station)
    @journey_log << current_journey
  end

  def finish(station)
    @current_journey.finish(station)
    @journey_log.pop
    @journey_log << current_journey
    @current_journey = nil
  end

  def journeys
    @journey_log.dup
  end

  private

  attr_reader :journey_class

  # def current_journey(station)
  #   current_journey || journey(station)
  # end

  def journey(station)
    journey_class.new(station)
  end

end
