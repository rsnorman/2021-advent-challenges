class CrabAligner
  attr_reader :crabs

  def initialize(crab_positions = '', fuel_use_calculator: :linear, verbose: false)
    @crabs = tokenize(crab_positions)
    @fuel_use_calculator = fuel_use_calculator
  end

  def ideal_position
    fuel_per_position = Array.new(@crabs.max + 1)

    (@crabs.max + 1).times do |position|
      fuel_per_position[position] = {
        fuel: @crabs.sum do |crab_position|
                calculate_fuel_cost(crab_position, position)
              end,
        position: position
      }
    end

    puts "Minimum Fuel Usage: #{fuel_per_position.min { |x,y| x[:fuel] <=> y[:fuel] }}"
    fuel_per_position.min { |x,y| x[:fuel] <=> y[:fuel] }[:position]
  end

  private

  def calculate_fuel_cost(crab_position, proposed_position)
    distance = (crab_position - proposed_position).abs
    if @fuel_use_calculator == :linear
      distance
    elsif @fuel_use_calculator == :sequential
      (distance * (distance + 1)) / 2
    end
  end

  def tokenize(crab_positions)
    crab_positions.split(',').map(&:to_i)
  end
end
