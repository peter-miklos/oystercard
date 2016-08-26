require_relative 'journey'

class JourneyLog

  attr_reader :current_journey, :journey_log

  def initialize(journey_class: Journey)
    @journey_log = []
    @journey_class = journey_class
  end


  def start(station = nil)
    fare = 0
    if @current_journey
      @current_journey = current_journey(station)
      fare = @current_journey.fare
      @journeys << @current_journey
      @current_journey = nil
    end
    @current_journey = current_journey(station)
    fare
    # fare = 0
    # if current_journey
    #   fare = @current_journey.fare
    #   @current_journey = nil
    # end
    # @current_journey = journey(station)
    # @journey_log << current_journey
    # fare
  end

  def finish(station)
    if !@current_journey
      @current_journey = current_journey
      fare = @current_journey.fare
      @journeys << @current_journey
      @current_journey = nil
    else
    end



    # fare = 0
    # if !@current_journey
    #   @current_journey = journey(nil)
    #   @current_journey.finish(station)
    #   @journeys << current_journey
    #   fare = @current_journey.fare
    # else
    #   @current_journey.finish(station)
    #   @journey_log.pop
    #   @journey_log << current_journey
    # end
    # @current_journey = nil
    # fare
  end

  def journeys
    @journey_log.dup
  end

  def fare
    @current_journey.fare
  end

  def in_journey?
    !!@current_journey
  end

  private

  attr_reader :journey_class

  def current_journey(station)
    current_journey || journey(station)
  end

  def journey(station)
    journey_class.new(station)
  end

end
