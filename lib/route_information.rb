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

  def shortest_distance(from, to)
    # find all routes from X - Y
    # get the min distance.
    # to optimise we can just discard any that's bigger than one that exists already
    #
  end

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


# find all the ones starting at the starting station
# find where they go,
