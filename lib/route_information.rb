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

  private

  def get_total_distance(destinations, total_distance = [])
    return total_distance.inject(&:+) if destinations.count < 2
    total_distance << routes.fetch(destinations[0]){return 'NO SUCH ROUTE'}.fetch(destinations[1]) { return 'NO SUCH ROUTE' }
    get_total_distance(destinations.drop(1), total_distance)
  end
end
