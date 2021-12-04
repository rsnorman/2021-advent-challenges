class DepthComparer
  COMPARISONS = [
    NO_PREVIOUS = 'N/A - no previous measurement',
    DECREASED = 'decreased',
    INCREASED = 'increased',
    NO_CHANGE = 'no change'
  ]

  class DepthWindow
    include Comparable

    def initialize(*depths)
      @depths = depths
    end

    def average
      @depths.sum / @depths.size.to_f
    end

    def <=>(other)
      average <=> other.average
    end

    def depth
      @depths.sum
    end
  end

  class NilDepth
    def average
      nil
    end

    def <=>(other)
      average <=> other.average
    end
  end

  def initialize(depths, window: 1, verbose: false)
    @depths = depths.split("\n").collect(&:to_i)
    @previous_depth = NilDepth.new
    @position = 0
    @increase_count = 0
    @decrease_count = 0
    @unchanged_count = 0
    @window = window
    @verbose = verbose
  end

  def measure_all
    while current_depth
      step
    end
  end

  def step
    msg = nil
    if @previous_depth.is_a?(NilDepth)
      msg = NO_PREVIOUS
      @unchanged_count += 1
    elsif current_depth < @previous_depth
      msg = DECREASED
      @decrease_count += 1
    elsif current_depth > @previous_depth
      msg = INCREASED
      @increase_count += 1
    elsif current_depth == @previous_depth
      msg = NO_CHANGE
      @unchanged_count += 1
    end

    puts "#{current_depth.depth} (#{msg})" if @verbose

    @previous_depth = current_depth
    @position += 1
    msg
  end

  def increase_count
    @increase_count
  end

  def decrease_count
    @decrease_count
  end

  def unchanged_count
    @unchanged_count
  end

  def total_depth_measurements
    @total_depth_measurements ||= @depths.size - ([@window - 1, 0].max)
  end

  def current_depth
    return nil if @position >= total_depth_measurements

    DepthWindow.new(*@depths.slice(@position, @window))
  end
end
