class Journey
  include Comparable

  attr_reader :stages

  def initialize
    @stages = []
  end

  def add_stage(stage)
    stage.journey = self
    stage.start_station.journey = self
    stage.end_station.journey = self
    @stages << stage
  end

  def total_distance
    stages.map(&:distance).inject(&:+)
  end

  def find_stage_distance(start_station, end_station)
    find_stage(start_station, end_station).map(&:distance).inject(&:+)
  end

  def find_stage(start_station, end_station)
    stages.select do |stage|
      stage.start_station == start_station && stage.end_station == end_station
    end
  end

  def <=>(other)
    total_distance <=> other.total_distance
  end

  def to_s
    @stages.map(&:to_s).join('  -->  ')
  end
end
