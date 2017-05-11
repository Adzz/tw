class RouteInformation
  attr_reader :routes

  def initialize
    @routes = {}
  end

  def add_route(start_station, end_station, distance)
    existing_start_station = @routes[start_station]
    if existing_start_station
      existing_start_station.merge!({ end_station => distance })
    else
      @routes.merge!({ start_station => { end_station => distance }})
    end
  end

  def distance(route)
    get_total_distance(route.split('-'))
  end

  def shortest_distance(route)
    start_station, end_station, *rest = route.split('-')
    all_journeys_from_to(start_station, end_station).map(&method(:distance)).min
  end

  private

  def all_journeys_from_to(start_station, end_station)
    all_journeys_to(end_station).select do |journey|
      journey.first == start_station
    end.map do |journey|
      journey.join('-')
    end
  end

  def all_journeys_to(end_station, nodes = @routes, current_journey = [], all_journeys =[])
    nodes.each do |node, _distance|
      current_journey  << "#{node}"

      if leaf_node?(node)
        if current_journey.last == end_station
          all_journeys << current_journey.dup
        end
        current_journey .pop
        next
      end

      if routes[node][end_station]
        current_journey << "#{end_station}"
        all_journeys << current_journey.dup
        current_journey.pop
      end

      all_journeys_to(end_station, routes[node], current_journey, all_journeys)
      current_journey.pop
    end
    all_journeys.uniq
  end

  def leaf_node?(node)
    routes[node].nil?
  end

  def get_total_distance(destinations, total_distance = [])
    return total_distance.inject(&:+) if destinations.count < 2
    total_distance << one_stop_distance(destinations[0], destinations[1])
    get_total_distance(destinations.drop(1), total_distance)
  end

  def one_stop_distance(start, finish)
    error = RouteFinderError::NoSuchRoute.new
    routes.fetch(start) { raise error }.fetch(finish) { raise error }
  end
end

