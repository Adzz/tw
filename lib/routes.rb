class Routes
  def initialize
    @routes = []
  end

  attr_reader :routes

  def add_stage(start_station, end_station, distance)
    start_station = Station.new(start_station)
    end_station = Station.new(end_station)
    stage = Stage.new(start_station, end_station, distance)
    @routes << Journey.new.add_stage(stage)
  end

  def find_stage_distances(start_station, end_station)
    distances = routes.select do |journey|
      journey.find_stage_distance(start_station, end_station)
    end
    return 'NO SUCH ROUTE' unless distances
    distances
  end

  def find_stages(start_station, end_station)
    stages = routes.select do |journey|
      journey.find_stage(start_station, end_station)
    end
    return 'NO SUCH ROUTE' unless stages
    stages
  end
end
