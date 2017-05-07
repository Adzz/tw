class RouteInformation
  def initialize
    @paths = []
  end

  def add_route(start_station, end_station, distance)
    @paths << { start_station => { end_station => distance }}
  end

  def all_routes
  end
end
