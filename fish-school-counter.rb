require_relative 'lanternfish.rb'

class FishSchoolCounter
  attr_reader :fish

  def initialize(fish_timers = '', strategy: :slow, verbose: false)
    @strategy = strategy
    @fish = tokenize(fish_timers)
    @new_fish = []
    @current_day = 0
  end

  def tick
    if @strategy == :slow
      @fish.each(&:tick)
      @new_fish.each do |new_fish|
        new_fish.on_lanternfish_create do |fish|
          @new_fish << fish
        end
        @fish << new_fish
      end
      @new_fish = []
    elsif @strategy == :fast
      fish_timer_counts = Array.new(9)
      new_fish = 0
      @fish.each.with_index do |fish, index|
        if index.zero?
          new_fish = fish
        else
          fish_timer_counts[index - 1] = fish
        end
      end

      fish_timer_counts[6] += new_fish
      fish_timer_counts[8] = new_fish
      @fish = fish_timer_counts
    end
  end

  def tick_days(count)
    count.times { tick }
  end

  def school_size
    if @strategy == :slow
      @fish.size
    elsif @strategy == :fast
      @fish.sum
    end
  end

  private

  def tokenize(fish_timers)
    if @strategy == :slow
      fish_timers.split(',').collect do |timer|
        Lanternfish.new(timer.to_i)
      end.each do |fish|
        fish.on_lanternfish_create do |fish|
          @new_fish << fish
        end
      end
    elsif @strategy == :fast
      fish = Array.new(9, 0)
      fish_timers.split(',').map(&:to_i).each do |timer|
        fish[timer] += 1
      end
      fish
    end
  end
end
