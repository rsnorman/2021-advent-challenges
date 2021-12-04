require 'rspec'
require_relative '../power-measurer.rb'

RSpec.describe PowerMeasurer do
  describe '#gamma_rate' do
    context 'with single measurment' do
      subject { described_class.new('10110') }

      it 'returns decimal format of first measurement' do
        expect(subject.gamma_rate).to eq 22
      end
    end

    context 'with multiple measurements' do
      subject { described_class.new("10110\n01001\n10010") }

      it 'returns decimal format of most commmon bits' do
        expect(subject.gamma_rate).to eq 18
      end
    end
  end

  describe '#epsilon_rate' do
    context 'with single measurment' do
      subject { described_class.new('10110') }

      it 'returns decimal format of first measurement' do
        expect(subject.epsilon_rate).to eq 9
      end
    end

    context 'with multiple measurements' do
      subject { described_class.new("10110\n01001\n10010") }

      it 'returns decimal format of most commmon bits' do
        expect(subject.epsilon_rate).to eq 13
      end
    end
  end

  describe '#oxygen_generator_rating' do
    context 'with single measurement' do
      subject { described_class.new('10110') }

      it 'returns decimal format of first measurement' do
        expect(subject.oxygen_generator_rating).to eq 22
      end
    end

    context 'with multiple measurements' do
      subject { described_class.new("00100\n11110\n10110") }

      it 'returns decimal format of first measurement' do
        expect(subject.oxygen_generator_rating).to eq 30
      end
    end
  end

  describe '#co2_scrubber_rating' do
    context 'with single measurement' do
      subject { described_class.new("10110\n00111\n01101") }

      it 'returns decimal format of first measurement' do
        expect(subject.co2_scrubber_rating).to eq 22
      end
    end

    context 'with multiple measurements and multiple iterations' do
      subject { described_class.new("00100\n01110\n10110\n11000") }

      it 'returns decimal format of first measurement' do
        expect(subject.co2_scrubber_rating).to eq 4
      end
    end
  end

  describe '#total_power' do
    subject { described_class.new("10110\n01001\n10010") }

    it 'returns gamma rate times epsilon rate' do
      expect(subject.total_power).to eq 234
    end
  end

  describe '#life_support_rating' do
    subject { described_class.new("00100\n01110\n10110\n11000") }

    it 'returns oxygen generator rating times co2 scrubber rating' do
      expect(subject.life_support_rating).to eq 96
    end
  end

  describe '#most_common_bit' do
    context 'with single measurement and 1 in first spot' do
      subject { described_class.new('10110') }

      it 'returns 1' do
        expect(subject.most_common_bit(0)).to eq 1
      end
    end

    context 'with single measurement and 0 in first spot' do
      subject { described_class.new('00110') }

      it 'returns 0' do
        expect(subject.most_common_bit(0)).to eq 0
      end
    end

    context 'with multiple measurement and 1 most common' do
      subject { described_class.new("00110\n11101\n11100") }

      it 'returns 1' do
        expect(subject.most_common_bit(0)).to eq 1
      end
    end

    context 'with multiple measurement and 0 most common' do
      subject { described_class.new("10110\n01101\n01100") }

      it 'returns 0' do
        expect(subject.most_common_bit(0)).to eq 0
      end
    end

    context 'with different bit position' do
      context 'with multiple measurement and 1 most common' do
        subject { described_class.new("00010\n01101\n11100") }

        it 'returns 1' do
          expect(subject.most_common_bit(2)).to eq 1
        end
      end

      context 'with multiple measurement and 0 most common' do
        subject { described_class.new("10110\n11001\n01000") }

        it 'returns 0' do
          expect(subject.most_common_bit(2)).to eq 0
        end
      end
    end

    context 'with bit values equal' do
      subject { described_class.new("100\n110") }

      it 'returns 1' do
        expect(subject.most_common_bit(1)).to eq 1
      end
    end
  end

  describe '#least_common_bit' do
    context 'with single measurement and 1 in first spot' do
      subject { described_class.new('10110') }

      it 'returns 0' do
        expect(subject.least_common_bit(0)).to eq 0
      end
    end

    context 'with single measurement and 0 in first spot' do
      subject { described_class.new('00110') }

      it 'returns 1' do
        expect(subject.least_common_bit(0)).to eq 1
      end
    end

    context 'with multiple measurement and 1 most common' do
      subject { described_class.new("00110\n11101\n11100") }

      it 'returns 0' do
        expect(subject.least_common_bit(0)).to eq 0
      end
    end

    context 'with multiple measurement and 0 most common' do
      subject { described_class.new("10110\n01101\n01100") }

      it 'returns 1' do
        expect(subject.least_common_bit(0)).to eq 1
      end
    end

    context 'with different bit position' do
      context 'with multiple measurement and 1 most common' do
        subject { described_class.new("00010\n01101\n11100") }

        it 'returns 0' do
          expect(subject.least_common_bit(2)).to eq 0
        end
      end

      context 'with multiple measurement and 0 most common' do
        subject { described_class.new("10110\n11001\n01000") }

        it 'returns 1' do
          expect(subject.least_common_bit(2)).to eq 1
        end
      end
    end

    context 'with bit values equal' do
      subject { described_class.new("100\n110") }

      it 'returns 0' do
        expect(subject.least_common_bit(1)).to eq 0
      end
    end
  end

  describe '#bit_matched_measurements' do
    context 'with 1 matching measurement in first position' do
      subject { described_class.new("01110\n11111") }

      it 'returns measurement with 1 in first position' do
        expect(subject.bit_matched_measurements(1, 0).map(&:bits).map(&:join)).to eq(['11111'])
      end
    end

    context 'with multiple matching measurement in first position' do
      subject { described_class.new("01110\n11111\n11110") }

      it 'returns measurement with 0 in second position' do
        expect(subject.bit_matched_measurements(0, 4).map(&:bits).map(&:join))
          .to eq(['01110', '11110'])
      end
    end
  end
end
