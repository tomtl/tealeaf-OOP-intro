class Hand
  include Comparable
  
  attr_reader :value
  
  def initialize(v)
    @value = v
  end

  def <=>(another_hand)
    if @value == another_hand.value
      0
    elsif (@value == 'p' && another_hand.value =='r') || 
            (@value == 'r' && another_hand.value == 's' )|| 
            (@value == 's' && another_hand.value == 'p')
      1
    else
      -1
    end
  end
  
  def display_winning_message
    case @value
      when 'p' then puts "Paper wraps Rock!"
      when 'r' then puts "Rock smashes Scissors!"
      when 's' then puts "Scissors cut Paper!"
    end
  end
  
end


class Player
  attr_accessor :hand
  attr_reader :name
  
  def initialize(n)
    @name = n
  end
  
  def to_s
    "#{name} currently has a choice of #{Game::CHOICES[self.hand.value]}."
  end
end


class Human < Player
  def pick_hand
    begin
      puts "Pick one: (p, r, s):"
      c = gets.chomp.downcase
    end until Game::CHOICES.keys.include?(c)
    
    self.hand = Hand.new(c)
  end
end


class Computer < Player
  def pick_hand
    self.hand = Hand.new(Game::CHOICES.keys.sample)
  end
end


class Game
  CHOICES = { "p" => "Paper", "r" => "Rock", "s" => "Scissors"}
  
  attr_reader :player, :computer
  
  def initialize
    @player = Human.new("You")
    @computer = Computer.new("Computer")
  end
  
  def display_welcome_message
    puts "Welcome to Rock, Paper Scissors!"
    puts "It's the normal rules: rock beats scissors, scissors beat paper, and paper beats rock."
  end
  
  def compare_hands
    if player.hand == computer.hand
      puts "It's a tie!"
    elsif player.hand > computer.hand
      player.hand.display_winning_message
      puts "You won!"
    else
      computer.hand.display_winning_message
      puts "You lost."
    end
  end
  
  def ask_play_again
    puts "Would you like to play again? (y/n)."
    play_again = gets.chomp.downcase
    until ['y', 'n'].include?(play_again)
      puts "Thats not a valid entry. Please type 'y' or 'n'."
      play_again = gets.chomp.downcase
    end
    return play_again
  end
  
  def display_exit_message
    puts "Thanks for playing!"
  end
  
  def play
    begin
      display_welcome_message
      player.pick_hand
      computer.pick_hand
      puts player
      puts computer
      compare_hands
      # play_again = ask_play_again
    end while ask_play_again == 'y'
  display_exit_message
  end
end

game = Game.new.play
