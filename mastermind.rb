module Mastermind


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

  def self=(code)
    @code = code
  end

  def [](index)
    @code[index]
  end

  def include?(value)
    @code.include?(value)
  end
end


class Board

  def initialize
      @guesses = []
      @responses = []
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

  def last_guess
    @guesses.last
  end

  def this_turn
    @guesses.size + 1
  end

  def last_turn
    @guesses.size
  end

  def display
    if this_turn == 1
      puts "No guesses yet."
    else
      (1..last_turn).each do |turn|
        print "Guess \##{turn}: "
        print @guesses[turn-1]
        print "   |  "
        print @responses[turn-1]
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

  def to_s
    "#{@correct} correct, #{@wrong_place} right color but wrong place."
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
    @secret_code = Row.new("code_string")
  end

  def respond(guess)
    correct = 0
    wrong_place = 0
    (0..3).each do |index|
      letter = guess[index]
      if @secret_code[index] == guess[index]
        correct += 1
      elsif @secret_code.include?(guess[index])
        wrong_place +=1
      end
    end
    Response.new(correct, wrong_place)
  end

  private

  def colors
    ["A", "B", "C", "D", "E", "F"]
  end
end

class Human < Player
  def guess
    print "Take a guess (4 letters A-F, can repeat): "
    gets.chomp.upcase
  end
end



class Game
  attr_accessor :codemaker, :codebreaker, :score, :board

  def initialize
    @codemaker = AI.new
    @codebreaker = Human.new
    @board = Board.new
    @score = 0
  end

  def start
    get_code
    puts "The codemaker has just devised a secret code, 4 letters long, A-F. (Example: FBCA)."
    puts "Time to match wits against the machine!"
    12.times {take_turn}
  end

  def get_code
    codemaker.devise_code
  end

  def take_turn
    board.display
    get_guess(codebreaker)
    get_response(codemaker)
  end

  def get_guess(codebreaker)
    guess = codebreaker.guess
    input_guess(guess)
  end

  def get_response(codemaker)
    guess = board.last_guess
    response = codemaker.respond(guess)
    input_response(response)
  end

  def input_guess(guess)
    board.input_guess(guess)
  end

  def input_response(response)
    board.input_response(response)
  end
end

end

include Mastermind

g = Game.new
g.start
