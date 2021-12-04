require_relative 'depth-comparer.rb'
require_relative 'course-reader.rb'

class ChallengeRunner
  INPUTS = {
    day1: {
      real: 'sub-depths',
      test: 'test-depths'
    },
    day2: {
      real: 'sub-navigation',
      test: 'test-sub-navigation'
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
end

ChallengeRunner.run(*ARGV)
