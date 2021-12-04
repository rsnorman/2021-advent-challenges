require_relative 'depth-comparer.rb'

class ChallengeRunner
  def self.run
    new.run
  end

  def run
    comparer = DepthComparer.new(File.read('input/sub-depths.txt'), verbose: true)
    comparer.measure_all
    puts "Total Depth Increases: #{comparer.increase_count}"
    puts "Total Depth Decreases: #{comparer.decrease_count}"
    puts "Total Depth Measurements: #{comparer.total_depth_measurements}"
  end
end

ChallengeRunner.run
