require_relative 'depth-comparer.rb'
require_relative 'course-reader.rb'
require_relative 'power-measurer.rb'
require_relative 'sub_games/bingo-game.rb'
require_relative 'vent-mapper.rb'
require_relative 'fish-school-counter.rb'
require_relative 'crab-aligner.rb'

class ChallengeRunner
  INPUTS = {
    day1: {
      real: 'sub-depths',
      test: 'test-depths'
    },
    day2: {
      real: 'sub-navigation',
      test: 'test-sub-navigation'
    },
    day3: {
      real: 'power-measurements',
      test: 'test-power-measurements'
    },
    day4: {
      real: 'bingo-game',
      test: 'test-bingo-game'
    },
    day5: {
      real: 'vent-lines',
      test: 'test-vent-lines'
    },
    day6: {
      real: 'fish-school',
      test: 'test-fish-school'
    },
    day7: {
      real: 'crab-positions',
      test: 'test-crab-positions'
    }
  }

  def self.run(*args)
    new(*args).run
  end

  def initialize(day, challenge, input_type = :real)
    @day = day
    @challenge = challenge
    @input_type = input_type
  end

  def run
    input = get_input(@input_type.to_sym)
    send("day#{@day}_challenge#{@challenge}", input)
  end

  def get_input(input_type)
    File.read("input/#{INPUTS["day#{@day}".to_sym][input_type.to_sym]}.txt")
  end

  def day1_challenge1(input)
    comparer = DepthComparer.new(input, verbose: true)
    comparer.measure_all
    puts "Total Depth Increases: #{comparer.increase_count}"
    puts "Total Depth Decreases: #{comparer.decrease_count}"
    puts "Total Depth Unchanges: #{comparer.unchanged_count}"
    puts "Total Depth Measurements: #{comparer.total_depth_measurements}"
  end

  def day1_challenge2(input)
    comparer = DepthComparer.new(input, window: 3, verbose: true)
    comparer.measure_all
    puts "Total Depth Increases: #{comparer.increase_count}"
    puts "Total Depth Decreases: #{comparer.decrease_count}"
    puts "Total Depth Unchanges: #{comparer.unchanged_count}"
    puts "Total Depth Measurements: #{comparer.total_depth_measurements}"
  end

  def day2_challenge1(input)
    reader = CourseReader.new(input, verbose: true)
    puts "Total Moves: #{reader.total_moves}"
    puts "Total Depth: #{reader.total_depth}"
    puts "Horizontal Progress: #{reader.total_horizontal_progress}"
    puts "Course Multiplied: #{reader.course_multiplied}"
  end

  def day2_challenge2(input)
    reader = CourseReader.new(input, verbose: true)
    reader.read_all
    puts "Total Moves: #{reader.total_moves}"
    puts "Total Depth: #{reader.total_depth}"
    puts "Horizontal Progress: #{reader.total_horizontal_progress}"
    puts "Course Multiplied: #{reader.course_multiplied}"
  end

  def day3_challenge1(input)
    measurer = PowerMeasurer.new(input, verbose: true)
    puts "Total Measurements: #{measurer.total_measurements}"
    puts "Total Gamma Rate: #{measurer.gamma_rate}"
    puts "Total Epsilon Rate: #{measurer.epsilon_rate}"
    puts "Total Power: #{measurer.total_power}"
  end

  def day3_challenge2(input)
    measurer = PowerMeasurer.new(input, verbose: true)
    puts "Total Measurements: #{measurer.total_measurements}"
    puts "Oxygen Generator Rating: #{measurer.oxygen_generator_rating}"
    puts "CO2 Scrubber Rating: #{measurer.co2_scrubber_rating}"
    puts "Life Support Rating: #{measurer.life_support_rating}"
  end

  def day4_challenge1(input)
    game = BingoGame.new(input, verbose: true)
    game.call_all
    puts "Winning Board Score: #{game.winning_board_score}"
  end

  def day4_challenge2(input)
    game = BingoGame.new(input, verbose: true)
    game.call_all
    puts "Winning Board Score: #{game.last_winning_board_score}"
  end

  def day5_challenge1(input)
    mapper = VentMapper.new(input, verbose: true)
    puts "Total Vents: #{mapper.vents.size}"
    puts "Total Overlap Points: #{mapper.overlap_points}"
  end

  def day6_challenge1(input)
    counter = FishSchoolCounter.new(input, strategy: :slow, verbose: true)
    puts "Total Start Fish: #{counter.school_size}"
    counter.tick_days(80)
    puts "Total End Fish: #{counter.school_size}"
  end

  def day6_challenge2(input)
    counter = FishSchoolCounter.new(input, strategy: :fast, verbose: true)
    puts "Total Start Fish: #{counter.school_size}"
    counter.tick_days(256)
    puts "Total End Fish: #{counter.school_size}"
  end

  def day7_challenge1(input)
    aligner = CrabAligner.new(input, verbose: true)
    puts "Total Crabs: #{aligner.crabs.size}"
    puts "Ideal Position: #{aligner.ideal_position}"
  end

  def day7_challenge2(input)
    aligner = CrabAligner.new(input, fuel_use_calculator: :sequential, verbose: true)
    puts "Total Crabs: #{aligner.crabs.size}"
    puts "Ideal Position: #{aligner.ideal_position}"
  end
end

ChallengeRunner.run(*ARGV)
