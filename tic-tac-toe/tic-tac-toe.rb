
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
    positions.select { |key, value| value != "X" && value != "o" }.keys
  end
  
  def available?(position)
    positions.select { |key, value| value != "X" && value != "o" }.keys.include?(position)
  end

  def player_picks(marker)
    positions.select { |_, value| value == marker}.keys
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
    board.player_picks(marker)
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
    puts current_player == person ? "You are first." : "Computer went first."
  end

  def current_player_turn
    if current_player == person
      pick = player_pick
    elsif current_player == computer
      pick = computer_pick   
    end
    @board.update(pick, current_player.marker)
  end

  def player_pick
    begin
      puts "=> Pick a position (1-9):"
      pick = gets.chomp
    end until @board.available?(pick.to_i)
    pick
  end

  def potential_winning_combinations
    # from winning combinations, subtract positions already picked by computer
    win_combos_minus_computer_picks = []
    Board::WINNING_COMBINATIONS.each do |combo| 
      win_combos_minus_computer_picks << (combo - board.player_picks(computer.marker))
    end
    win_combos_minus_computer_picks # array of arrays
  end

  def available_winning_combinations
    # subtract combinations blocked by person
    win_combos_minus_computer_picks = potential_winning_combinations
    available_win_combos = []
    win_combos_minus_computer_picks.each do |combo| 
      available_win_combos << combo if (combo & board.player_picks(person.marker)).empty?
    end
    available_win_combos # array of arrays
  end

  def winning_combination_lengths
    # lengths of available combinations
    available_winning_combos = available_winning_combinations  
    combo_lengths = []
    available_winning_combos.each { |combo| combo_lengths << combo.length }
    combo_lengths # array of integers
  end

  def best_winning_combinations
    available_win_combos = available_winning_combinations
    combo_lengths = winning_combination_lengths  
    best_combos = []
    available_win_combos.each do |combo| 
      best_combos << combo if combo.length == combo_lengths.min
    end
    best_combos # array of arrays
  end

  def computer_pick
    if best_winning_combinations.empty?
      board.available.sample
    else
      best_winning_combinations.sample.sample
    end
  end

  def increment_turn_count
    @turn_count += 1
  end

  def alternate_player
    if current_player == person
      @current_player = @computer
    else
      @current_player = @person
    end
  end

  def clear_screen
    system "cls"
    system "clear"
  end

  def short_pause
    sleep(1)
  end

  def display_board
    short_pause
    clear_screen
    board.draw
  end

  def welcome_message
    "Welcome to tic-tac-toe!"
  end

  def win_message(marker)
    if turn_count >= 9
      "It's a tie"
    elsif marker == person.marker
      "You win!"
    elsif marker == computer.marker
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
      display_board
      current_player_turn
      increment_turn_count
      winner = board.check_for_winner(current_player.marker)
      alternate_player
    end until winner || turn_count >= 9
    display_board
    puts win_message(winner)
    puts "Thanks for playing!"
  end
end

Game.new.run
