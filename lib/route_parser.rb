require 'csv'

Dir[File.join(File.dirname(__FILE__), "../lib/**/*.rb")].each { |f| require f }

class RouteParser
  def initialize(file_path, route_info = RouteInformation.new)
    validate_file(file_path)
    @route_info = route_info
  end

  def parse
    CSV.foreach(file_path) do |row|
      start_station, end_station, distance, *rest = row.first.split('')
      route_info.add_route(start_station, end_station, distance.to_i)
    end
  end

  private

  attr_reader :file_path, :route_info

  def validate_file(file_path)
    raise ArgumentError, "please provide a correct file" if file_path.nil? || !File.exist?(file_path)
    @file_path = file_path
  end
end
