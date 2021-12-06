require_relative 'lanternfish.rb'

class FishSchoolCounter
  attr_reader :fish

  def initialize(fish_timers = '', verbose: false)
    @fish = tokenize(fish_timers)
    @new_fish = []
    @current_day = 0
  end

  def tick
    @fish.each(&:tick)
    @new_fish.each do |new_fish|
      new_fish.on_lanternfish_create do |fish|
        @new_fish << fish
      end
      @fish << new_fish
    end
    @new_fish = []
  end

  def tick_days(count)
    count.times { tick }
  end

  private

  def tokenize(fish_timers)
    fish_timers.split(',').collect do |timer|
      Lanternfish.new(timer.to_i)
    end.each do |fish|
      fish.on_lanternfish_create do |fish|
        @new_fish << fish
      end
    end
  end
end
