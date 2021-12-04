class BingoBoard
  def initialize(spots)
    @spots = tokenize(spots)
    build_config
    @marked_spots = []
  end

  def spots
    @spots.map { |row| row.map(&:number) }
  end

  def daub(number)
    @spots.each do |row|
      row.each do |spot|
        spot.mark if spot.number == number
      end
    end
  end

  def winner?
    @potential_winning_configs.any?(&:complete?)
  end

  def marked_spots
    @spots.flatten.select(&:marked?).map(&:number)
  end

  private

  class Spot
    attr_reader :number

    def initialize(number)
      @number = number
      @marked = false
    end

    def mark
      @marked = true
    end

    def marked?
      @marked
    end
  end

  class PotentialWinningConfig
    def initialize(spots)
      @spots = spots
    end

    def complete?
      @spots.all?(&:marked?)
    end
  end

  def spot?(number)
    @spots.flatten.include?(number)
  end

  def build_config
    @potential_winning_configs = []

    @spots.each do |row|
      @potential_winning_configs << PotentialWinningConfig.new(row)
    end

    @spots.transpose.each do |column|
      @potential_winning_configs << PotentialWinningConfig.new(column)
    end
  end

  def tokenize(spots)
    spots.split("\n").collect do |row|
      row.split(' ').map(&:to_i).collect { |number| Spot.new(number) }
    end
  end
end
