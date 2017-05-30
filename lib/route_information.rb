require 'pry'
require_relative "priority_queue"

class Dijkstra
  def initialize(routes, source_station)
    @routes = routes
    @source_station = source_station
    @path_to = {}
    @distance_to = {}
    @pq = PriorityQueue.new
  end

  def shortest_path_to(station)
    binding.pry
    compute_shortest_path

    path = []
    while station != @source_station
      path.unshift(station)
      station = @path_to[station]
    end

    path.unshift(@source_station)
  end

  private

  def compute_shortest_path
    update_distance_of_all_edges_to(Float::INFINITY)
    @distance_to[@source_station] = 0

    @pq.insert(@source_station, 0)
    while @pq.any?
      station = @pq.remove_min
      station.destinations.each do |destination|
        update_shortest_journey(destination)
      end
    end
  end

  def update_distance_of_all_edges_to(distance)
    @routes.stations.each do |station|
      @distance_to[station] = distance
    end
  end

  def update_shortest_journey(stage)
    return if @distance_to[stage.start_station] <= @distance_to[stage.end_station] + stage.distance

    @distance_to[stage.start_station] = @distance_to[stage.end_station] + stage.distance
    @path_to[stage.start_station] = stage.end_station
    @pq.insert(stage.start_station, @distance_to[stage.start_station])
  end
end


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
    binding.pry
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
    # when do we mark as visited?
    nodes.each do |node, _distance|
      current_journey  << "#{node}"
      visited = {node => true}

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
        next if visited[node]
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

