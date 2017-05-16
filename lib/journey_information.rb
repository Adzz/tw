class JourneyInformation
  def initialize(journey = Journey.new, stage_klass = Stage)
    @journey = journey
    @stage_klass = stage
  end

  def add_stage(start_station, end_station, distance)
    journey.add_stage(stage_klass.new(start_station, end_station, distance))
  end

  def find_stage(start_station, end_station)
    stage = journey.find_stage(start_station, end_station)
    return 'NO SUCH ROUTE' unless journey.find_stage(start_station, end_station)
  end

  private

  attr_reader :stage_klass, :journey
end
