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
    most_common_bits = []
    total_bits.times do |position|
      most_common_bits << most_common_bit(position)
    end
    Binary.to_decimal(most_common_bits.join(''))
  end

  def epsilon_rate
    least_common_bits = []
    total_bits.times do |position|
      least_common_bits << least_common_bit(position)
    end
    Binary.to_decimal(least_common_bits.join(''))
  end

  def life_support_rating
    oxygen_generator_rating * co2_scrubber_rating
  end

  def oxygen_generator_rating
    remaining_measurements = @measurements

    total_bits.times do |position|
      bit_value = most_common_bit(position, remaining_measurements)
      remaining_measurements = bit_matched_measurements(bit_value, position, remaining_measurements)

      break if remaining_measurements.size == 1
    end

    raise 'Could not find single oxygen generator measurement' if remaining_measurements.size > 1

    Binary.to_decimal(remaining_measurements.first.bits.join(''))
  end

  def co2_scrubber_rating
    remaining_measurements = @measurements

    total_bits.times do |position|
      bit_value = least_common_bit(position, remaining_measurements)
      remaining_measurements = bit_matched_measurements(bit_value, position, remaining_measurements)

      break if remaining_measurements.size == 1
    end

    raise 'Could not find single oxygen generator measurement' if remaining_measurements.size > 1

    Binary.to_decimal(remaining_measurements.first.bits.join(''))
  end

  def most_common_bit(position, measurements = @measurements)
    find_most_common_bit(position, measurements)
  end

  def least_common_bit(position, measurements = @measurements)
    find_least_common_bit(position, measurements)
  end

  def bit_matched_measurements(bit_value, position, measurements = @measurements)
    measurements.select do |measurement|
      measurement.bits[position] == bit_value
    end
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

  def total_bits
    @measurements.first.bits.size
  end

  def tokenize(measurements)
    measurements.split("\n").collect do |measurement|
      Measurement.new(measurement.split('').map(&:to_i))
    end
  end

  def find_most_common_bit(position, measurements)
    bits = measurements.collect { |measurement| measurement.bits[position] }
    one_count = 0
    zero_count = 0

    for bit in bits do
      if bit == 0
        zero_count += 1
      else
        one_count += 1
      end
    end

    one_count >= zero_count ? 1 : 0
  end

  def find_least_common_bit(position, measurements)
    bits = measurements.collect { |measurement| measurement.bits[position] }
    one_count = 0
    zero_count = 0

    for bit in bits do
      if bit == 0
        zero_count += 1
      else
        one_count += 1
      end
    end

    one_count >= zero_count ? 0 : 1
  end
end
