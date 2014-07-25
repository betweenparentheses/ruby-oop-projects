module Tictactoe



class GameRunner
  attr_accessor :player1, :player2, :board

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = Board.new
  end

  def get_players
    print "Player 1, you will will be X. What's your name? "
    @player1.set_name(gets.chomp)
    @player1.set_mark("X")
    print "Player 2, you will be O. What's your name? "
    @player2.set_name(gets.chomp)
    @player2.set_mark("O")
  end

  def start
    puts "WELCOME TO OBJECT-ORIENTED TIC TAC TOE"
    puts "\n--------------------------------------------------------------"
    get_players
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

  def is_draw?
    grid.all? {|row| row.all {|box| box.full?}}
  end

  def winner?

    nil
  end

  def still_playing?
    !winner?  && !is_draw?
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
