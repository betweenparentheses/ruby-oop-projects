module Mastermind

class Game
  attr_accessor :codemaker, :codebreaker, :score

  def initialize
    @codemaker = AI.new
    @codebreaker = Human.new
    @board = Board.new
    @score = 0
  end

  def start
    get_code
    (1..12).each {|turn| take_turn(turn)}
  end

  def get_code
    code = codemaker.devise_code
  end

  def take_turn
    board.display
    guess(codebreaker)
    answer(codemaker)
  end

  def guess(codebreaker, turn)
    codebreaker.guess(turn)
  end

  def answer(codemaker, turn)
    codemaker.respond(turn)
  end
end

#maybe
#class Score
#end


class Row
  attr_reader

  def initialize(code="")
    @code = code
  end

  def ==(other_thing)
    self.code == other_thing.code
  end

  def each
    self.code.each {yield}
  end

  def self=(code)
    @code = code
  end

end


class Board


  @code = Row.new
  @guesses = []
  @responses = []

  def initialize
  end

  def set_code(code)
    @code ||= code #test this to make sure it works
  end

  def input_guess(row)
    @guesses << row
  end

  def input_response(row)
    @responses << row
  end

  def this_turn
    @guesses.size-1
  end

  def display
    if this_turn == -1
      puts "No guesses yet."
    else
      (0..this_turn).each do |turn|
        print "Guess \##{turn+1}: "
        print @guesses[turn]
        print "   |  "
        print @responses[turn]
        puts "\n"
      end
    end
  end
end

# a row represents six colors with letters A - F


class Response
  attr_reader :correct, :wrong_place
  def initialize(correct, wrong_place)
    @correct = correct
    @wrong_place = wrong_place
  end
end


class Player
end

class AI < Player
  def devise_code
    code_string = ""
    4.times do
      letter = colors.sample
      code_string << letter
    end
    Row.new("code_string")
  end

  private

  def colors
    ["A", "B", "C", "D", "E", "F"]
  end
end

class Human < Player

end

end

include Mastermind

g = Game.new
g.start
