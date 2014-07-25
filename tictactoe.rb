module Tictactoe



class GameRunner
  attr_accessor :player1, :player2, :board, :current_player

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = Board.new
    @current_player = nil
  end

  def get_players
    print "Player 1, you will will be X. What's your name? "
    @player1.set_name(gets.chomp)
    @player1.set_mark("X")
    print "Player 2, you will be O. What's your name? "
    @player2.set_name(gets.chomp)
    @player2.set_mark("O")
  end

  def get_move(player)
    puts "\nPlease input a place (1-9) to mark your #{player.mark}: "
    player.mark_move(gets.chomp)
  end

  def take_turns(player1, player2)
    board.draw
    get_move(current_player)
    current_player = current_player == player1 ? player2 : player1
  end

  def start
    puts "WELCOME TO OBJECT-ORIENTED TIC TAC TOE"
    puts "\n--------------------------------------------------------------"

    get_players
    current_player = [player1,player2].sample
    puts "Congratulations, #{current_player}. You won the coin toss and go first."

    take_turns(player1, player2) while board.still_playing?

    if board.is_draw?
      puts "\nGAME OVER. It's a draw."
    else
      puts "WE HAVE A WINNER! #{winner} has won the day!"
      puts "Thanks for playing!"
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

  def set_mark (mark)
    @mark = mark
  end

  def == (other_player)
    self.mark == other_player.mark && self.name == other_player.name
  end

end

class Board
  attr_reader :grid
  def initialize
    @grid = Array.new(3){Array.new(3){Box.new}}
  end

  def mark_move(index, player)
    position(index).mark(player)
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

  def is_draw?
    grid.all? {|row| row.all? {|box| box.full?}}
  end

  def three_in_a_row(mark)
    return mark if grid.any? {|row| row.all? {|value| value == mark}}
    return mark if grid.transpose.any? {|column| column.all? {|value| value == mark}}
    return mark if position(1) == mark && position(5) == mark && position(9) == mark
    return mark if position(3) == mark && position(5) == mark && position(7) == mark
    nil
  end

  def winner?
    return "X" if three_in_a_row("X")
    return "O" if three_in_a_row("O")
    false
  end

  def still_playing?
    !winner?  && !is_draw?
  end

  def draw
     puts "#{value_at(1)}|#{value_at(2)}|#{value_at(3)}"
     puts "------"
     puts "#{value_at(4)}|#{value_at(5)}|#{value_at(6)}"
     puts "------"
     puts "#{value_at(7)}|#{value_at(8)}|#{value_at(9)}"
  end

end

class Box
  attr_accessor :value
  attr_accessor :owner

  def initialize (value = nil, owner = nil)
    @value = value
    @owner = owner
  end

  def mark_move(player)
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
end
end

include Tictactoe
g = GameRunner.new
g.start
