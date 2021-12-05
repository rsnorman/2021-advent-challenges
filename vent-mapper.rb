class VentMapper
  def initialize(vents = '', verbose: false)
    @vents = tokenize(vents)
    build_map
    map_vents
  end

  def vents
    @vents
  end

  def vent_map
    @vent_map
  end

  MIN_OVERLAPS = 2

  def overlap_points
    points = 0
    @vent_map.each do |row|
      row.each do |point|
        points += 1 if point >= MIN_OVERLAPS
      end
    end
    points
  end

  private

  class Vent
    Coordinate = Struct.new(:x, :y)

    attr_reader :start, :end

    def initialize(coordinates)
      @start = Coordinate.new(*coordinates.first)
      @end = Coordinate.new(*coordinates.last)
    end

    def line
      if @start.x == @end.x
        ([@start.y, @end.y].min..[@start.y, @end.y].max).to_a.collect do |y_pos|
          [@start.x, y_pos]
        end
      elsif @start.y == @end.y
        ([@start.x, @end.x].min..[@start.x, @end.x].max).to_a.collect do |x_pos|
          [x_pos, @start.y]
        end
      else
        raise "Unable to build line for #{@start} -> #{@end}"
      end
    end

    def straight?
      @start.x == @end.x || @start.y == @end.y
    end

    def ==(other)
      return super(other) if other.is_a?(Vent)

      [[@start.x, @start.y], [@end.x, @end.y]] == other
    end
  end

  def tokenize(vents)
    vents.split("\n").collect do |vent|
      vent_coordinates = vent.split(' -> ').collect do |coordinate|
        coordinate.split(',').map(&:to_i)
      end
      Vent.new(vent_coordinates)
    end
  end

  def build_map
    max_x_coord = -1
    max_y_coord = -1

    @vents.each do |vent|
      max_x_coord = [max_x_coord, vent.start.x + 1, vent.end.x + 1].max
      max_y_coord = [max_y_coord, vent.start.y + 1, vent.end.y + 1].max
    end

    @vent_map = []
    max_y_coord.times do
      @vent_map << Array.new(max_x_coord, 0)
    end
  end

  def map_vents
    @vents.select(&:straight?).collect(&:line).each do |line|
      line.each do |x, y|
        @vent_map[y][x] += 1
      end
    end
  end
end
