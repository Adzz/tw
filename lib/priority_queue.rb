class PriorityQueue
  def initialize
    @queue = {}
  end

  def any?
    @queue.any?
  end

  def insert(station, distance_from_source)
    @queue[station] = distance_from_source
    order_queue
  end

  def remove_min
    @queue.shift.first
  end

  private
  def order_queue
    @queue.sort_by {|_key, value| value }
  end
end
