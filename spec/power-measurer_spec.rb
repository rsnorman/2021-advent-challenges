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

  describe '#total_power' do
    subject { described_class.new("10110\n01001\n10010") }

    it 'returns gamma rate times epsilon rate' do
      expect(subject.total_power).to eq 234
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
  end
end
