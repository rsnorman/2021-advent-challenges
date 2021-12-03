class DepthMeasurer
  def initialize(depths = nil)
    @depths = depths || File.read('./input/sub-depths.txt')
  end

  def measure
    'N/A - no previous measurement'
  end
end

