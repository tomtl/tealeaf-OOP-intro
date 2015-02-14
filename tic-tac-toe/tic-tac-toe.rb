
class Board
  attr_reader :positions
  
  WINNING_COMBINATIONS =  [
    [1, 4, 7], [2, 5, 8], [3, 6, 9],  # verticals
    [1, 2, 3], [4, 5, 6], [7, 8, 9],  # horizontals
    [1, 5, 9], [3, 5, 7]              # diagonals
  ]
  
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
    board.available.include?(position)
  end
  
  def check_for_winner(player)
    person_positions = person.positions
    computer_positions = computer.positions
    WINNING_COMBINATIONS.each do |combination|
      if (combination & player_positions) == combination
        return true
      end
    end
    nil
  end
  
end

class Player
  def initialize
    puts "Player initialized."
  end

  def positions
    player_pieces = {"Person" => "X", "Computer" => "o"}
    player_positions = []
    board.each do |position, value|
      player_positions << position if value == player_pieces[name]
    end
    player_positions
  end
end


class Person < Player
  def ask_for_pick
    puts "=> Where do you want to go next?"
    user_pick = gets.chomp.to_i
    until Board.available?(user_pick)
      puts "=> Thats not a valid entry. Please enter a number for an available spot."
      user_pick = gets.chomp.to_i
    end
    return user_pick
  end  
end


class Computer < Player
  def pick
    board.available.sample
  end
end


class Game
  attr_accessor :person, :computer, :board
  
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
    begin
      board.draw
      person.ask_for_pick
      turn_count += 1
      break if board.check_for_winner(@person)
      computer.pick
      winner = board.check_for_winner(@computer)
    end until winner
    puts win_message(winner)
  end
end
  
Game.new.run