class DepthMeasurer
  def initialize(depths = nil)
    @depths = depths || File.read('./input/sub-depths.txt')
    @previous_depth = nil
    @counter = 0
  end

  def measure
    msg = nil
    if @previous_depth.nil?
      msg = 'N/A - no previous measurement'
    elsif current_depth < @previous_depth
      msg = 'decreased'
    elsif current_depth > @previous_depth
      msg = 'increased'
    elsif current_depth == @previous_depth
      msg = 'no change'
    end

    @previous_depth = current_depth
    @counter += 1
    msg
  end

  def current_depth
    depths[@counter]
  end

  def depths
    @depths.split("\n").collect(&:to_i)
  end
end

