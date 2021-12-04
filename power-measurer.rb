class PowerMeasurer
  def initialize(measurements, verbose: false)
    @measurements = tokenize(measurements)
  end

  def total_power
    gamma_rate * epsilon_rate
  end

  def total_measurements
    @measurements.size
  end

  def gamma_rate
    most_common_bits = [
      most_common_bit(0),
      most_common_bit(1),
      most_common_bit(2),
      most_common_bit(3),
      most_common_bit(4)
    ]
    Binary.to_decimal(most_common_bits.join(''))
  end

  def epsilon_rate
    least_common_bits = [
      least_common_bit(0),
      least_common_bit(1),
      least_common_bit(2),
      least_common_bit(3),
      least_common_bit(4)
    ]
    Binary.to_decimal(least_common_bits.join(''))
  end

  def most_common_bit(position)
    find_most_common_bit(position)
  end

  def least_common_bit(position)
    find_least_common_bit(position)
  end

  private

  Measurement = Struct.new(:bits)

  class Binary
    def self.to_decimal(binary)
      raise ArgumentError if binary.match?(/[^01]/)

      binary.reverse.chars.map.with_index do |digit, index|
        digit.to_i * 2**index
      end.sum
    end
  end

  def tokenize(measurements)
    measurements.split("\n").collect do |measurement|
      Measurement.new(measurement.split('').map(&:to_i))
    end
  end

  def find_most_common_bit(position)
    bits = @measurements.collect { |measurement| measurement.bits[position] }
    one_count = 0
    zero_count = 0

    for bit in bits do
      if bit == 0
        zero_count += 1
      else
        one_count += 1
      end
    end

    one_count > zero_count ? 1 : 0
  end

  def find_least_common_bit(position)
    bits = @measurements.collect { |measurement| measurement.bits[position] }
    one_count = 0
    zero_count = 0

    for bit in bits do
      if bit == 0
        zero_count += 1
      else
        one_count += 1
      end
    end

    one_count > zero_count ? 0 : 1
  end
end
