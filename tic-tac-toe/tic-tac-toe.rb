
class Board
  attr_reader :positions
  
  def initialize
    @positions = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5,
              6 => 6, 7 => 7, 8 => 8, 9 => 9}
  end
  
  def draw
    puts "-------------"
    puts "| #{positions[1]} | #{positions[2]} | #{positions[3]} |"
    puts "-------------"
    puts "| #{positions[4]} | #{positions[5]} | #{positions[6]} |"
    puts "-------------"
    puts "| #{positions[7]} | #{positions[8]} | #{positions[8]} |"
    puts "-------------"
  end
  
  def update(player, position)
    x_or_o = {"user" => "X", "computer" => "o"}
    self.positions[positions.key(position)] = x_or_o[player]
    positions
  end
  
  def available
    available_positions = []
    positions.each do |position, value|
      available_positions << position unless ["X", "o"].include?(value)
    end
    available_positions
  end
  
  def available?(position)
    positions.available.include?(position)
  end
  
  def check_for_winner
    # check if anyone won
    # check if tie
    # return winner (person/computer), tie or nil
  end
  
end

class Player
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

class Person < Player
  def ask_for_pick
    puts "=> Where do you want to go next?"
    user_pick = gets.chomp
    until positions.available?(user_pick.to_i)
      puts "=> Thats not a valid entry. Please enter a number for an available spot."
      user_pick = gets.chomp
    end
    return user_pick
  end 
end

class Computer < Player
  def pick
    # pick a good position
  end
end

class TicTacToe
  attr_accessor :player, :computer, :board
  def initialize
    @person = Person.new
    @computer = Computer.new
    @board = Board.new
  end
  
  def win_message(winner)
    case winner
      when "Person" then "You win!"
      when "Computer" then "You lose."
      when nil then "It's a draw."
    end
  end
  
  def run
    turn_count = 0
    until winner
      Board.draw
      Person.ask_for_pick
      turn_count += 1
      break if Board.check_for_winner
      Computer.pick
      winner = Board.check_for_winner
    end
    puts win_message(winner)
  end
end
  