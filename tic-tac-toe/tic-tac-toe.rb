# board class
# user class
# computer class

class Board
  attr_reader :board
  
  def initialize
    @board = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5,
              6 => 6, 7 => 7, 8 => 8, 9 => 9}
  end
  
  def draw
    puts "-------------"
    puts "| #{board[1]} | #{board[2]} | #{board[3]} |"
    puts "-------------"
    puts "| #{board[4]} | #{board[5]} | #{board[6]} |"
    puts "-------------"
    puts "| #{board[7]} | #{board[8]} | #{board[8]} |"
    puts "-------------"
  end
  
  def update(player, position)
    x_or_o = {"user" => "X", "computer" => "o"}
    self.board[board.key(position)] = x_or_o[player]
    board
  end
  
  def available
    available_positions = []
    board.each do |position, value|
      available_positions << position unless ["X", "o"].include?(value)
    end
    available_positions
  end
end