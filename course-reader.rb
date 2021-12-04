class CourseReader
  def initialize(moves = '', verbose: false)
    @moves = tokenize(moves)
    @aim = 0
    @horizontal_progress = 0
    @depth = 0
  end

  def total_depth
    @depth
  end

  def total_horizontal_progress
    @horizontal_progress
  end

  def total_moves
    @moves.size
  end

  def course_multiplied
    total_depth * total_horizontal_progress
  end

  def read_all
    for move in @moves do
      step(move)
    end
  end

  private

  Move = Struct.new(:direction, :distance)

  def tokenize(moves)
    moves.split("\n").collect do |line|
      Move.new(line.split(' ').first.to_sym, line.split(' ').last.to_i)
    end
  end

  def step(move)
    if move.direction == :up
      @aim -= move.distance
    elsif move.direction == :down
      @aim += move.distance
    elsif move.direction == :forward
      @horizontal_progress += move.distance
      @depth += move.distance * @aim
    end
  end
end
