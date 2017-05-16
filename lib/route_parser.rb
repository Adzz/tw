require 'csv'

Dir[File.join(File.dirname(__FILE__), "../lib/**/*.rb")].each { |f| require f }

class RouteParser
  def initialize(file_path, routes_klass = Routes.new)
    validate_file(file_path)
    @routes = routes
  end

  def parse
    CSV.foreach(file_path) do |row|
      # add error handling here
      # param argument validation
      start_station, end_station, distance, *rest = row.first.split('')
      routes.add_stage(start_station, end_station, distance.to_i)
    end
  end

  private

  attr_reader :file_path, :routes

  def validate_file(file_path)
    raise ArgumentError, "please provide a correct file" if file_path.nil? || !File.exist?(file_path)
    @file_path = file_path
  end
end
