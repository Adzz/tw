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
    start_station, next_station, *rest = route.split('-')
    binding.pry
    find_route(start_station, next_station)
    # get_total_distance(route.split('-'))
    # routes[start_station]include?(next_station)
  end

  # what we are looking for here is the connected routes - full paths
  #

  # def find_route(start_station, end_station, current_route =[], permutations =[])
  #   ss_routes = routes.fetch(start_station) { next }
  #   if ss_routes && ss_routes[end_station]
  #     current_route << start_station << end_station
  #     permutations << current_route.flatten
  #     current_route.clear
  #   else
  #     current_route.clear
  #   end
  #   ss_routes.keys.each do |key|
  #     current_route << start_station
  #     find_route(key, end_station, current_route, permutations)
  #   end
  #   permutations
  # end



  # def all_journeys_to(end_station, destinations = @routes, current_route = '', permutations =[])
  #   destinations.each do |destination, _distance|
  #     current_route += "#{destination}-"
  #     next unless routes[destination]
  #     if routes[destination].include?(end_station)
  #       current_route += "#{end_station}"
  #       permutations << current_route.dup
  #       current_route.clear
  #     else
  #       all_journeys_to(end_station, routes[destination], current_route, permutations)
  #     end
  #     current_route.clear
  #   end
  #   permutations
  # end

  # @stack = [start_station]

  def all_journeys_from_to(start_station, end_station, destinations = @routes, current_route = [], permutations =[])
    current_route = [start_station]
    current_station = current_route.pop

    loop do
      current_station = current_route.dup.pop
      return unless destinations[current_station]
      return permutations if current_destination.nil?
      # this captures too much; we still need to be sure we go to all the nodes
      if !destinations[current_station][end_station].nil?
        current_route << "#{end_station}"
        permutations << current_route.dup
        # end station
        current_route.pop
        # current station
        current_route.pop
        # then we need to skip to the next in the loop,
      # else
      #   all_journeys_to(start_station, end_station, routes[destination], current_route, permutations)
      end

    end
    permutations
  end

  # def thing(start_station, end_station, destinations = @routes, permutations =[])
  #   current_journey = [start_station]
  #   loop do
  #     current_destination = current_journey.pop
  #     return permutations if current_destination.nil?
  #     return permutations if routes[current_destination].nil?
  #     if routes[current_destination].include?(end_station)
  #       permutations << current_journey.dup
  #     end
  #     # find children of current destination
  #     # next_destinations = destinations[current_destination]
  #     next_destinations =
  #     current_journey << next_destinations
  #   end
  # end

  # we can find a one stop route easily
  # its a DFS for every start station key

  private

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


# at each level add the route to permutations if the
# station exists. Which means we need to keep track of the route

# find all the ones starting at the starting station
# find where they go,


# take starting station, use that on the graph to
