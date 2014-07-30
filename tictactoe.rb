module Tictactoe


#some of this class is pretty procedural because it actually runs the game using the others
class GameRunner
  attr_accessor :player1, :player2, :board, :current_player

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = Board.new
    @current_player = nil
  end

#TODO abstract into a hash of any number of players and marks
  def get_players
    print "Player 1, you will be X. What's your name? "
    @player1.set_name(gets.chomp)
    @player1.set_mark("X")
    print "Player 2, you will be O. What's your name? "
    @player2.set_name(gets.chomp)
    @player2.set_mark("O")
  end

def get_move(current_player)
      print "\nPlease input a place (1-9, from upper left to lower right) to "
      print "mark your #{current_player.mark}: "
      position = gets.chomp.to_i
  end

#core gameplay revolves around this
  def take_turns(player1, player2, current_player)
    puts "YOUR TURN, #{current_player.name.upcase}"
    board.draw
    index = get_move(current_player)
    while board.position(index) != nil || !((1..9) === index)
      if board.position(index) != nil
        puts "That's already taken."
      else
        puts "Sorry, that's not a good input."
      end
      index = get_move(current_player)
    end
    board.make_move(index, current_player)
    current_player == player1 ? player2 : player1
  end

  def start
    puts "WELCOME TO OBJECT-ORIENTED TIC TAC TOE"
    puts "\n--------------------------------------------------------------"

    get_players
    current_player = [player1,player2].sample
    puts "Congratulations, #{current_player.name}. You won the coin toss and go first."

    current_player = take_turns(player1, player2, current_player) while board.still_playing?
    board.draw
    if board.winner
      puts "\nWE HAVE A WINNER! #{board.winner} has won the day!"
      puts "Thanks for playing!"
    elsif board.is_draw?
      puts "\nGAME OVER. It's a draw."
    else
      puts "This is some confusing error here. Sorry."
    end
  end
end

class Player
  attr_accessor :name, :mark
  def initialize (name = nil, mark = nil)
      @name, @mark = name, mark
  end

  def set_name (name)
    @name = name
  end

#mark is your X or your O
  def set_mark (mark)
    @mark = mark
  end

  def mark
    @mark
  end

  def == (other_player)
    self.mark == other_player.mark && self.name == other_player.name
  end

end

class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(3){Array.new(3){Box.new}}
  end

  def make_move(index, player)
    position(index).make_mark(player)
  end

  def position(index)
    case index
      when 1; return grid[0][0]
      when 2; return grid[0][1]
      when 3; return grid[0][2]
      when 4; return grid[1][0]
      when 5; return grid[1][1]
      when 6; return grid[1][2]
      when 7; return grid[2][0]
      when 8; return grid[2][1]
      when 9; return grid[2][2]
      else; return nil
    end
  end

  def value_at(index)
    position(index).value || " "
  end

#draw as in stalemate
#TODO: rename to is_full to remove confusion. Currently only works to determine draw
#if you have already checked for a winner and come back falsy.
  def is_draw?
    grid.all? {|row| row.all? {|box| box.full?}}
  end

#returns who gets three in a row, not just a boolean. otherwise nil.
  def three_in_a_row(mark)
    return mark if grid.any? {|row| row.all? {|value| value == mark}}
    return mark if grid.transpose.any? {|column| column.all? {|value| value == mark}}
    return mark if position(1) == mark && position(5) == mark && position(9) == mark
    return mark if position(3) == mark && position(5) == mark && position(7) == mark
    nil
  end

  def winner
    return "X" if three_in_a_row("X")
    return "O" if three_in_a_row("O")
    nil
  end

  def still_playing?
    return true if winner.nil? && !is_draw?
    false
  end

#draws the board. not draw as in stalemate.
  def draw
     puts "\n\n#{value_at(1)}|#{value_at(2)}|#{value_at(3)}"
     puts "------"
     puts "#{value_at(4)}|#{value_at(5)}|#{value_at(6)}"
     puts "------"
     puts "#{value_at(7)}|#{value_at(8)}|#{value_at(9)}"
  end

end

#individual cells in the crosshatch grid of the Board
class Box
  attr_accessor :value
  attr_accessor :owner

#has a value, "X" or "O", and an owner, the player name
  def initialize (value = nil, owner = nil)
    @value = value
    @owner = owner
  end

  def make_mark(player)
    @value = player.mark
    @owner = player.name
    nil
  end

  def nil?
    value == nil
  end

  def full?
    !self.nil?
  end

  def ==(thing)
    value == thing
  end
end
end

include Tictactoe
g = GameRunner.new
g.start
