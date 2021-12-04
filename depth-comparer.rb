class DepthComparer
  COMPARISONS = [
    NO_PREVIOUS = 'N/A - no previous measurement',
    DECREASED = 'decreased',
    INCREASED = 'increased',
    NO_CHANGE = 'no change'
  ]

  def initialize(depths, verbose: false)
    @depths = depths.split("\n").collect(&:to_i)
    @previous_depth = nil
    @position = 0
    @increase_count = 0
    @decrease_count = 0
    @verbose = verbose
  end

  def measure_all
    while current_depth
      step
    end
  end

  def step
    msg = nil
    if @previous_depth.nil?
      msg = NO_PREVIOUS
    elsif current_depth < @previous_depth
      msg = DECREASED
      @decrease_count += 1
    elsif current_depth > @previous_depth
      msg = INCREASED
      @increase_count += 1
    elsif current_depth == @previous_depth
      msg = NO_CHANGE
    end

    puts "#{current_depth} (#{msg})" if @verbose

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

  def total_depth_measurements
    @depths.size
  end

  def current_depth
    @depths[@position]
  end
end

