
class Board
  attr_reader :positions
  
  WINNING_COMBINATIONS =  [
    [1, 4, 7], [2, 5, 8], [3, 6, 9],  # verticals
    [1, 2, 3], [4, 5, 6], [7, 8, 9],  # horizontals
    [1, 5, 9], [3, 5, 7]              # diagonals
  ]
  
  def initialize
    @positions = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9}
  end
  
  def draw
    puts "-------------"
    puts "| #{positions[1]} | #{positions[2]} | #{positions[3]} |"
    puts "-------------"
    puts "| #{positions[4]} | #{positions[5]} | #{positions[6]} |"
    puts "-------------"
    puts "| #{positions[7]} | #{positions[8]} | #{positions[9]} |"
    puts "-------------"
  end
  
  def update(position, marker)
    @positions[position.to_i] = marker
  end
  
  def available
    @positions.select { |key, value| value != "X" && value != "o" }.keys
  end
  
  def available?(position)
    @positions.select { |key, value| value != "X" && value != "o" }.keys.include?(position)
  end

  def player_picks(marker)
    @positions.select { |_, value| value == marker}.keys
  end
  
  def check_for_winner(marker)
    WINNING_COMBINATIONS.each do |combination|
      if (combination & player_picks(marker)) == combination
        return marker
      end
    end
    nil
  end
  
end

class Player
  attr_reader :marker
  def initialize(name, marker)
    @name = name
    @marker = marker
  end

  def picks
    @board.player_picks(@marker)
  end
end

class Game
  attr_accessor :person, :computer, :board, :current_player, :turn_count
  
  def initialize
    @person = Player.new("Bob", "X")
    @computer = Player.new("Marvin", "o")
    @board = Board.new
    @current_player = @person
    @turn_count = 0
  end
  
  def randomize_starting_player
    @current_player = [@person, @computer].sample
    puts @current_player == @person ? "You are first." : "Computer went first."
  end

  def current_player_turn
    if @current_player == @person
      pick = player_pick
    elsif @current_player == @computer
      pick = computer_pick   
    end
    @board.update(pick, @current_player.marker)
  end

  def player_pick
    begin
      puts "=> Pick a position (1-9):"
      pick = gets.chomp
    end until @board.available?(pick.to_i)
    pick
  end

  def computer_pick
    person_positions = @board.player_picks(@person.marker)
    computer_positions = @board.player_picks(@computer.marker)
      
    needed_for_win = []
    Board::WINNING_COMBINATIONS.each do |combo| 
      needed_for_win << (combo - computer_positions)
    end
      
    possible_win_combos = []
    needed_for_win.each do |combo| 
      possible_win_combos << combo if (combo & person_positions).empty?
    end
      
    combo_lengths = []
    possible_win_combos.each { |combo| combo_lengths << combo.length }
      
    best_combos = []
    if possible_win_combos.empty?
      best_combos << @board.available.sample 
    else
      possible_win_combos.each do |combo| 
        best_combos << combo if combo.length == combo_lengths.min
      end
    end
      
    best_combos.sample.sample
  end

  def increment_turn_count
    @turn_count += 1
  end

  def alternate_player
    if @current_player == @person
      @current_player = @computer
    else
      @current_player = @person
    end
  end

  def clear_screen
    system "cls"
  end

  def short_pause
    sleep(1)
  end

  def welcome_message
    "Welcome to tic-tac-toe!"
  end

  def win_message(marker)
    if @turn_count >= 9
      "It's a tie"
    elsif marker == @person.marker
      "You win!"
    elsif marker == @computer.marker
      "You lose."
    end
  end

  def ask_play_again
    puts "Would you like to play again? (y/n)."
    play_again = gets.chomp.downcase
    until ['y', 'n'].include?(play_again)
      puts "Thats not a valid entry. Please type 'y' or 'n'."
      play_again = gets.chomp.downcase
    end
    play_again
  end
  
  def run
    clear_screen
    puts welcome_message
    randomize_starting_player
    begin
      short_pause
      clear_screen
      board.draw
      current_player_turn
      increment_turn_count
      winner = board.check_for_winner(@current_player.marker)
      alternate_player
    end until winner || @turn_count >= 9
    system "cls"
    board.draw
    puts win_message(winner)
    puts "Thanks for playing!"
  end
end

Game.new.run
