require 'rspec'
require_relative '../depth-comparer.rb'

RSpec.describe DepthComparer do
  subject { described_class.new('100') }

  describe '#step' do
    context 'with no previous measurement' do
      it 'returns no previous measurement' do
        expect(subject.step).to eq 'N/A - no previous measurement'
      end
    end

    context 'with second measurement a decrease in depth' do
      subject { described_class.new("100\n99") }

      before { subject.step }

      it 'returns decrease' do
        expect(subject.step).to eq 'decreased'
      end
    end

    context 'with second measurement greater than first' do
      subject { described_class.new("100\n101") }

      before { subject.step }

      it 'returns increase' do
        expect(subject.step).to eq 'increased'
      end
    end

    context 'with second measurement the same as first' do
      subject { described_class.new("100\n100") }

      before { subject.step }

      it 'returns no change' do
        expect(subject.step).to eq 'no change'
      end
    end

    context 'with third measurment less than second' do
      subject { described_class.new("100\n99\n98") }

      before { subject.step; subject.step }

      it 'returns increase' do
        expect(subject.step).to eq 'decreased'
      end
    end

    context 'with third measurment greater than second' do
      subject { described_class.new("100\n99\n100") }

      before { subject.step; subject.step }

      it 'returns increase' do
        expect(subject.step).to eq 'increased'
      end
    end

    context 'with depth window of 3' do
      subject { described_class.new("100\n101\n200\n", window: 3) }

      context 'with no previous measurement' do
        it 'returns no previous measurement' do
          expect(subject.step).to eq 'N/A - no previous measurement'
        end
      end

      context 'with second measurement a decrease in depth' do
        subject { described_class.new("100\n101\n98\n80", window: 3) }

        before { subject.step }

        it 'returns decrease' do
          expect(subject.step).to eq 'decreased'
        end
      end

      context 'with second measurement greater than first' do
        subject { described_class.new("100\n101\n99\n200", window: 3) }

        before { subject.step }

        it 'returns increase' do
          expect(subject.step).to eq 'increased'
        end
      end

      context 'with second measurement the same as first' do
        subject { described_class.new("100\n100\n50\n100", window: 3) }

        before { subject.step }

        it 'returns no change' do
          expect(subject.step).to eq 'no change'
        end
      end
    end
  end

  describe '#total_depth_measurements' do
    subject { described_class.new("100\n200") }

    it 'returns total depth measurements' do
      expect(subject.total_depth_measurements).to eq 2
    end

    context 'with depth window of 3' do
      subject { described_class.new("100\n200\n300", window: 3) }

      it 'returns total depth measurements' do
        expect(subject.total_depth_measurements).to eq 1
      end

      context 'with multiple depth windows' do
        subject { described_class.new("100\n200\n300\n100", window: 3) }

        it 'returns total depth measurements' do
          expect(subject.total_depth_measurements).to eq 2
        end
      end
    end
  end

  describe '#increase_count' do
    context 'with no previous measurement' do
      before { subject.measure_all }

      it 'returns zero' do
        expect(subject.increase_count).to be_zero
      end
    end

    context 'with second measurement a decrease in depth' do
      subject { described_class.new("100\n99") }

      before { subject.measure_all }

      it 'returns zero' do
        expect(subject.increase_count).to be_zero
      end
    end

    context 'with second measurement greater than first' do
      subject { described_class.new("100\n101") }

      before { subject.measure_all }

      it 'returns 1' do
        expect(subject.increase_count).to eq 1
      end
    end

    context 'with second measurement the same as first' do
      subject { described_class.new("100\n100") }

      before { subject.measure_all }

      it 'returns zero' do
        expect(subject.increase_count).to be_zero
      end
    end

    context 'with all measurements decreasing' do
      subject { described_class.new("100\n99\n98") }

      before { subject.measure_all }

      it 'returns zero' do
        expect(subject.increase_count).to be_zero
      end
    end

    context 'with 1 measurement increasing in depth' do
      subject { described_class.new("100\n99\n100") }

      before { subject.measure_all }

      it 'returns 1' do
        expect(subject.increase_count).to eq 1
      end
    end

    context 'with all measurements increasing in depth' do
      subject { described_class.new("100\n101\n200") }

      before { subject.measure_all }

      it 'returns 2' do
        expect(subject.increase_count).to eq 2
      end
    end

    context 'with depth window of 3' do
      context 'with no previous measurement' do
        subject { described_class.new("100\n200\n100\n", window: 3) }

        before { subject.measure_all }

        it 'returns zero' do
          expect(subject.increase_count).to be_zero
        end
      end

      context 'with second measurement a decrease in depth' do
        subject { described_class.new("100\n99\n101\n50", window: 3) }

        before { subject.measure_all }

        it 'returns zero' do
          expect(subject.increase_count).to be_zero
        end
      end

      context 'with second measurement greater than first' do
        subject { described_class.new("100\n101\n100\n150", window: 3) }

        before { subject.measure_all }

        it 'returns 1' do
          expect(subject.increase_count).to eq 1
        end
      end

      context 'with second measurement the same as first' do
        subject { described_class.new("100\n100\n50\n100", window: 3) }

        before { subject.measure_all }

        it 'returns zero' do
          expect(subject.increase_count).to be_zero
        end
      end

      context 'with all measurements decreasing' do
        subject { described_class.new("100\n99\n98\n97\n96", window: 3) }

        before { subject.measure_all }

        it 'returns zero' do
          expect(subject.increase_count).to be_zero
        end
      end

      context 'with 1 measurement increasing in depth' do
        subject { described_class.new("100\n99\n100\n101\n50", window: 3) }

        before { subject.measure_all }

        it 'returns 1' do
          expect(subject.increase_count).to eq 1
        end
      end

      context 'with all measurements increasing in depth' do
        subject { described_class.new("100\n101\n200\n202\n215", window: 3) }

        before { subject.measure_all }

        it 'returns 2' do
          expect(subject.increase_count).to eq 2
        end
      end
    end
  end

  describe '#decrease_count' do
    context 'with no previous measurement' do
      before { subject.measure_all }

      it 'returns zero' do
        expect(subject.decrease_count).to be_zero
      end
    end

    context 'with second measurement a decrease in depth' do
      subject { described_class.new("100\n99") }

      before { subject.measure_all }

      it 'returns 1' do
        expect(subject.decrease_count).to eq 1
      end
    end

    context 'with second measurement greater than first' do
      subject { described_class.new("100\n101") }

      before { subject.measure_all }

      it 'returns zero' do
        expect(subject.decrease_count).to be_zero
      end
    end

    context 'with second measurement the same as first' do
      subject { described_class.new("100\n100") }

      before { subject.measure_all }

      it 'returns zero' do
        expect(subject.decrease_count).to be_zero
      end
    end

    context 'with all measurements decreasing' do
      subject { described_class.new("100\n99\n98") }

      before { subject.measure_all }

      it 'returns 2' do
        expect(subject.decrease_count).to eq 2
      end
    end

    context 'with 1 measurement decreasing in depth' do
      subject { described_class.new("100\n99\n100") }

      before { subject.measure_all }

      it 'returns 1' do
        expect(subject.decrease_count).to eq 1
      end
    end

    context 'with all measurements increasing in depth' do
      subject { described_class.new("100\n101\n200") }

      before { subject.measure_all }

      it 'returns 0' do
        expect(subject.decrease_count).to be_zero
      end
    end

    context 'with depth window of 3' do
      context 'with no previous measurement' do
        subject { described_class.new("100\n200\n100\n", window: 3) }

        before { subject.measure_all }

        it 'returns zero' do
          expect(subject.decrease_count).to be_zero
        end
      end

      context 'with second measurement a decrease in depth' do
        subject { described_class.new("100\n99\n101\n50", window: 3) }

        before { subject.measure_all }

        it 'returns 1' do
          expect(subject.decrease_count).to eq 1
        end
      end

      context 'with second measurement greater than first' do
        subject { described_class.new("100\n101\n100\n150", window: 3) }

        before { subject.measure_all }

        it 'returns zero' do
          expect(subject.decrease_count).to be_zero
        end
      end

      context 'with second measurement the same as first' do
        subject { described_class.new("100\n100\n50\n100", window: 3) }

        before { subject.measure_all }

        it 'returns zero' do
          expect(subject.decrease_count).to be_zero
        end
      end

      context 'with all measurements decreasing' do
        subject { described_class.new("100\n99\n98\n97\n96", window: 3) }

        before { subject.measure_all }

        it 'returns 2' do
          expect(subject.decrease_count).to eq 2
        end
      end

      context 'with 1 measurement decreasing in depth' do
        subject { described_class.new("100\n99\n100\n101\n50", window: 3) }

        before { subject.measure_all }

        it 'returns 1' do
          expect(subject.decrease_count).to eq 1
        end
      end

      context 'with all measurements increasing in depth' do
        subject { described_class.new("100\n101\n200\n202\n215", window: 3) }

        before { subject.measure_all }

        it 'returns 0' do
          expect(subject.decrease_count).to be_zero
        end
      end
    end
  end
end
