module Mastermind



# a row represents six colors with letters A - F
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

  def count(letter)
    @code.count(letter)
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

  def last_response
    @responses.last
  end
  
  def last_correct
    last_response.correct #breaks Demeter in a bad way. How do I fix this?
  end
  
  def last_wrong_place
    last_response.wrong_place
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


class Response
  attr_reader :correct, :wrong_place
  def initialize(correct, wrong_place)
    @correct = correct
    @wrong_place = wrong_place
  end

  def to_s
    "#{@correct} correct, #{@wrong_place} right letter but wrong place."
  end

  def all_correct?
    @correct == 4
  end
end


class Player
  
private
  
  def colors
    ["A", "B", "C", "D", "E", "F"]
  end
end

class AI < Player

  def devise_code
    code_string = ""
    4.times do
      letter = colors.sample
      code_string << letter
    end
    @secret_code = Row.new(code_string)
  end

  def respond(guess)
    correct = 0
    wrong_place = 0
    p @secret_code
    (0..3).each do |index|
      letter = guess[index]
      if @secret_code[index] == letter
        correct += 1
      elsif @secret_code.include? (letter)
        wrong_place += 1
      end
    end
    Response.new(correct, wrong_place)
  end
  
  def guess(board)
    case board.this_turn
    when 1
      @letters = {}    
      @all_possible_guesses = []
      colors.each do |first|
        colors.each do |second|
          colors.each do |third|
            colors.each do |fourth|
              @all_possible_guesses << "#{first}#{second}#{third}#{fourth}"
            end
          end
        end
      end
      p @all_possible_guesses.sample
      return "AAAA"
    when 2
      @letters["A"] = board.last_correct + board.last_wrong_place
      @all_possible_guesses.select! { |code| code.count("A") == @letters["A"]}
      return "BBBB"
    when 3
      @letters["B"] = board.last_correct + board.last_wrong_place
      @all_possible_guesses.select! { |code| code.count("B") == @letters["B"]}
      return "CCCC"    
    when 4
      @letters["C"] = board.last_correct + board.last_wrong_place
      @all_possible_guesses.select! { |code| code.count("C") == @letters["C"]}
      return "DDDD"
    when 5
      @letters["D"] = board.last_correct + board.last_wrong_place
      @all_possible_guesses.select! { |code| code.count("D") == @letters["D"]}
      return "EEEE"
    when 6
      @letters["E"] = board.last_correct + board.last_wrong_place
      @all_possible_guesses.select! { |code| code.count("E") == @letters["E"]}
      return "FFFF"
    when 7
      @letters["F"] = board.last_correct + board.last_wrong_place
      @all_possible_guesses.select! { |code| code.count("F") == @letters["F"]}
      return @all_possible_guesses.sample
    else 
      @all_possible_guesses.select! {|code| code != board.last_guess}
      p @all_possible_guesses
      return @all_possible_guesses.sample
    end
  end
end

class Human < Player
  #only takes board to match ducktype of the AI version
  def guess(board)
    print "Take a guess (4 letters A-F, can repeat): "
    gets.chomp.upcase
  end
  
  def devise_code
     print "What's the secret code this time (4 letters A-F, can repeat letters)? "
     code_string = gets.chomp.upcase
     until code_string.length == 4 do
       print "That doesn't seem right. Try again: "
       code_string = gets.chomp.upcase
     end
     @secret_code = Row.new(code_string)
  end
  
  def respond(guess)
    correct = 0
    wrong_place = 0
    p @secret_code
    (0..3).each do |index|
      letter = guess[index]
      if @secret_code[index] == letter
        correct += 1
      elsif @secret_code.include? (letter)
        wrong_place += 1
      end
    end
    response = Response.new(correct, wrong_place)
    puts "The computer guessed #{guess}. As you know, that means it got #{response}"
    response
  end

end



class Game
  attr_accessor :codemaker, :codebreaker, :score, :board

  def initialize
    @board = Board.new
    @score = 0
  end

  def start
    choose_sides
    get_code
    puts "The codemaker has just devised a secret code, 4 letters long, A-F. (Example: FBCA)."
    puts "Time to match wits against the machine!"
    12.times {take_turn}
  end
  
  def choose_sides
    puts "Do you want to be the\nA) CODEMAKER \nor the \nB)CODEBREAKER?"
    print "(choose A or B):"
    answer = gets.chomp.upcase
    until answer == "A" || answer == "B"
     print "Try again. That's not an answer: "
     answer = gets.chomp.upcase
    end
    set_sides(answer)
  end
 
 def set_sides(answer)
   case answer
   when "A"
     @codemaker = Human.new
     @codebreaker = AI.new
   when "B"
     @codemaker = AI.new
     @codebreaker = Human.new
   end
 end

  def get_code
    codemaker.devise_code
  end

  def take_turn
    board.display
    get_guess(codebreaker)
    get_response(codemaker)
    if won?
      puts "Congratulations, codebreaker! You guessed it on turn #{board.this_turn}."
      exit
    end
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

  def won?
    last_response = board.last_response
    last_response.all_correct?
  end
end

end

include Mastermind

g = Game.new
g.start
