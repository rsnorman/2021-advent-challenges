require 'rspec'
require_relative '../../sub_games/bingo-game.rb'

RSpec.describe BingoGame do
  describe '#number_calls' do
    subject { described_class.new('1,2,3,98,54,21,8') }

    it 'returns all number calls' do
      expect(subject.number_calls).to eq([1,2,3,98,54,21,8])
    end

    context 'with board games' do
      subject { described_class.new("1,2,3,98,54,21,8\n\n 1  2\n 3  4") }

      it 'returns all number calls' do
        expect(subject.number_calls).to eq([1,2,3,98,54,21,8])
      end
    end
  end

  describe '#board_games' do
    subject { described_class.new("1,2,3,98,54,21,8\n\n1 2\n3 4") }

    it 'returns 1 board game' do
      expect(subject.boards.first).to eq([[1,2],[3,4]])
    end

    context 'with multiple board games' do
      subject { described_class.new("1,2,3,98,54,21,8\n\n1 2\n3 4\n\n5 6\n7 8") }

      it 'returns 2 board games' do
        expect(subject.boards).to eq([[[1,2],[3,4]], [[5,6],[7,8]]])
      end
    end
  end

  describe '#call_number' do
    before do
      subject.call_number
    end

    subject { described_class.new("1,4,8,54,2,8\n\n1 2\n3 4\n\n5 6\n7 8") }

    it 'marks number on board' do
      expect(subject.boards.first.marked_spots).to include 1
    end

    context 'with multiple calls' do
      before do
        subject.call_number
        subject.call_number
        subject.call_number
      end

      it 'marks numbers on first board' do
        expect(subject.boards.first.marked_spots).to eq([1,4])
      end

      it 'marks numbers on second board' do
        expect(subject.boards[1].marked_spots).to eq([8])
      end
    end

    context 'with enough numbers called for a win' do
      before do
        subject.call_number
        subject.call_number
        subject.call_number
        subject.call_number
      end

      it 'marks the first board as a winner' do
        expect(subject.boards.first).to be_winner
      end

      it 'doesn\'t mark the second board as a winner' do
        expect(subject.boards[1]).to_not be_winner
      end
    end
  end

  describe '#call_all' do
    before do
      subject.call_all
    end

    subject { described_class.new("1,4,8,54,2,6\n\n1 2\n3 4\n\n5 6\n7 8") }

    it 'marks the first board as a winner' do
      expect(subject.boards.first).to be_winner
    end

    it 'doesn\'t mark the second board as a winner' do
      expect(subject.boards[1]).to_not be_winner
    end
  end

  describe '#winning_board_score' do
    before do
      subject.call_all
    end

    subject { described_class.new("1,4,8,54,2,6\n\n1 2\n3 4\n\n5 6\n7 8") }

    it 'returns winning board score' do
      expect(subject.winning_board_score).to eq 6
    end
  end
end
