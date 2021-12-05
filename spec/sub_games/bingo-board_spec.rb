require 'rspec'
require_relative '../../sub_games/bingo-board.rb'

RSpec.describe BingoBoard do
  describe '#spots' do
    subject { described_class.new(" 1  2  3\n 4  5  6\n7  8  9") }

    it 'returns all board spots' do
      expect(subject.spots).to eq([[1,2,3], [4,5,6], [7,8,9]])
    end
  end

  describe '#daub' do
    subject { described_class.new("1 2 3\n4 5 6\n7 8 9") }

    context 'with number on the board' do
      before { subject.daub(1) }

      it 'adds number as marked' do
        expect(subject.marked_spots).to include 1
      end
    end

    context 'with number not on board' do
      before { subject.daub(-1) }

      it 'doesn\'t add any marked numbers' do
        expect(subject.marked_spots).to_not include -1
      end
    end

    context 'with multiple numbers daubed on board' do
      before do
        subject.daub(1)
        subject.daub(-1)
        subject.daub(7)
      end

      it 'adds number as marked' do
        expect(subject.marked_spots).to eq([1, 7])
      end
    end
  end

  describe '#winner?' do
    subject { described_class.new("1 2 3\n4 5 6\n7 8 9") }

    context 'with no numbers marked' do
      it 'returns false' do
        expect(subject).to_not be_winner
      end
    end

    context 'with no rows or columns all marked' do
      it 'returns false' do
        expect(subject).to_not be_winner
      end
    end

    context 'with all numbers in row marked' do
      before do
        subject.daub(4)
        subject.daub(5)
        subject.daub(6)
      end

      it 'returns true' do
        expect(subject).to be_winner
      end
    end

    context 'with all numbers in column marked' do
      before do
        subject.daub(2)
        subject.daub(5)
        subject.daub(8)
      end

      it 'returns true' do
        expect(subject).to be_winner
      end
    end
  end

  describe '#score' do
    subject { described_class.new("1 2 3\n4 5 6\n7 8 9") }

    context 'with not a winner' do
      it 'returns 0' do
        expect(subject.score).to be_zero
      end
    end

    context 'with all numbers in row marked' do
      before do
        subject.daub(4)
        subject.daub(5)
        subject.daub(6)
      end

      it 'returns sum of all unmarked numbers times last marked number' do
        expect(subject.score).to eq 180
      end
    end

    context 'with all numbers in column marked' do
      before do
        subject.daub(2)
        subject.daub(5)
        subject.daub(8)
      end

      it 'returns sum of all unmarked numbers times last marked number' do
        expect(subject.score).to eq 240
      end
    end
  end
end
