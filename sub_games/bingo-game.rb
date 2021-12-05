require_relative 'bingo-board.rb'

class BingoGame
  def initialize(bingo_game_details, verbose: false)
    @number_calls, @boards = tokenize(bingo_game_details)
    @current_call = 0
  end

  def number_calls
    @number_calls
  end

  def boards
    @boards
  end

  def call_all
    @number_calls.size.times do
      call_number

      break if winning_board?
    end
  end

  def call_number
    number = @number_calls[@current_call]
    @boards.each do |board|
      board.daub(number)
    end
    @current_call += 1
  end

  def winning_board?
    @boards.any?(&:winner?)
  end

  def winning_board_score
    @boards.find(&:winner?).score
  end

  private

  def tokenize(bingo_game_details)
    calls = bingo_game_details.split("\n\n").first.split(' ').map(&:to_i)
    boards = bingo_game_details.split("\n\n")[1..-1].map { |spots| BingoBoard.new(spots) }
    [calls, boards]
  end
end
