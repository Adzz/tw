class Station
  attr_accessor :journey

  def initialize(name)
    @name = name
  end

  def destinations
    journey.stages.select{ |stage| stage.start_station == self }
  end

  def to_s
    @name
  end
end
