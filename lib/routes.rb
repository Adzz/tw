class Routes
  def initialize
    @routes = []
    @stages = []
  end

  attr_reader :routes, :stages

  def stations
    @stations ||= @stages.flat_map { |stage| [stage.start_station, stage.end_station] }
  end

  def add_stage(start_station, end_station, distance)
    start_station = Station.new(start_station)
    end_station = Station.new(end_station)
    @stages << Stage.new(start_station, end_station, distance)
  end

  def distance(route)
    get_total_distance(route.split('-'))
  end
# this is just the journey distance.
# if we generate all the paths then we can sum each, select any that's relevant etc etc
# the number of journeys is infinite though, because they can loop
# graph is directed. if we loop, we need to know, and we need to terminate the search
  def get_total_distance(destinations, total_distance = [])
    return total_distance.inject(&:+) if destinations.count < 2
    total_distance << one_stop_distance(destinations[0], destinations[1])
    get_total_distance(destinations.drop(1), total_distance)
  end


  def generate_possible_journeys_from_stages(stages = @stages, journey = Journey.new)
    stages.each do |stage|
      next_stages = stages.select do |other_stage|
        other_stage.start_station.to_s == stage.end_station.to_s || other_stage.to_s == stage.to_s
      end

      break if @routes.map(&:to_s).include?(next_stages.map(&:to_s).join('  -->  ')) || next_stages == [stage]

      next_stages.each do |stage|
        journey.add_stage(stage)
      end
    end
    binding.pry
    @routes << journey
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
