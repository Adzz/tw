class Stage
  include Comparable

  attr_reader :start_station, :end_station :distance
  attr_accessor :journey

  def initialize(start_station, end_station, distance)
    @start_station, @end_station, @distance = start_station, end_station, distance
  end

  def <=>(other)
    @distance <=> other.distance
  end
end
