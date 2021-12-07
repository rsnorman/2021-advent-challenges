require 'rspec'
require_relative '../crab-aligner.rb'

RSpec.describe CrabAligner do
  describe '#crabs' do
    context 'with no input' do
      subject { described_class.new }

      it 'returns empty array' do
        expect(subject.crabs).to be_empty
      end
    end

    context 'with one crab' do
      subject { described_class.new('3') }

      it 'returns one crab' do
        expect(subject.crabs).to eq([3])
      end
    end

    context 'with multiple crabs' do
      subject { described_class.new('3,15,0') }

      it 'returns multiple crab' do
        expect(subject.crabs).to eq([3, 15, 0])
      end
    end
  end

  describe '#ideal_position' do
    context 'with linear fuel use calculator' do
      context 'with single crab' do
        subject { described_class.new('3') }

        it 'returns position of crab' do
          expect(subject.ideal_position).to eq 3
        end
      end

      context 'with multiple crabs' do
        subject { described_class.new('16,1,2,0,4,2,7,1,2,14') }

        it 'returns position that uses least amount of fuel' do
          expect(subject.ideal_position).to eq 2
        end
      end
    end

    context 'with sequential increase fuel use calculator' do
      context 'with single crab' do
        subject { described_class.new('3', fuel_use_calculator: :sequential) }

        it 'returns position of crab' do
          expect(subject.ideal_position).to eq 3
        end
      end

      context 'with multiple crabs' do
        subject { described_class.new('16,1,2,0,4,2,7,1,2,14', fuel_use_calculator: :sequential) }

        it 'returns position that uses least amount of fuel' do
          expect(subject.ideal_position).to eq 5
        end
      end
    end
  end
end
