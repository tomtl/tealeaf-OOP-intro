# blackjack-oo.rb

# Tealeaf course 1, lesson 2
# Tom Lee, Feb 16, 2014

class Deck
  attr_accessor :cards

  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King", "Ace"]
  SUITS = ["Clubs", "Diamonds", "Hearts", "Spades"]
  VALUES = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9, 
            10 => 10, "Jack" => 10, "Queen" => 10, "King" => 10, "Ace" => 11 }

  def initialize
    @cards = []
    build_deck
  end

  def build_deck
    2.times do
      RANKS.each do |rank|
        SUITS.each do |suit|
          @cards << Card.new(rank, suit)
        end
      end
    end
  end

  def deal_one_card
    cards.shuffle!.pop
  end
end

class Card
  attr_accessor :rank, :suit, :value

  def initialize (rank, suit)
    @rank = rank
    @suit = suit
    @value = Deck::VALUES[rank]
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Player
  attr_accessor :hand, :score

  def initialize
    @hand = []
    @score = 0
  end

  def add_card_to_hand(card)
    hand << card
    update_player_score
  end

  def update_player_score
    if score > 21 && aces_count > 0
      calculate_hand_value_with_aces
    else
      calculate_hand_value_without_aces
    end
    score
  end

  def calculate_hand_value_with_aces
    ace_cards_count = aces_count
    ace_cards_value = ace_cards_count * 11
    while ace_cards_count > 0
      ace_cards_count -= 1
      ace_cards_value -= 10
      value = non_aces_value + ace_cards_value
      break if value <= 21
    end
    @score = value
  end

  def calculate_hand_value_without_aces
    @score = 0
    hand.each { |card| @score += card.value }
    score
  end

  def aces_count
    hand.select { |card| card.rank == "Ace" }.count
  end

  def non_aces_value
    non_ace_cards = hand.select { |card| card.rank != "Ace" }
    non_ace_cards_value = 0
    non_ace_cards.each { |card| non_ace_cards_value += card.value}
    non_ace_cards_value
  end

  def to_s
    "#{@hand}"
  end

end

class Game
  attr_reader :deck, :person , :computer

  def initialize
    @deck = Deck.new
    @person = Player.new
    @computer = Player.new
  end

  def clear_screen
    system "cls"
    system "clear"
  end

  def display_welcome_message
    puts "Welcome to Blackjack!"
  end

  def display_initial_cards
    puts "Your cards are: #{person.hand}. Score: #{person.score}"
    puts "Dealer's first card is #{computer.hand.first}"
  end

  def display_all_cards
    puts "Your cards are: #{person.hand}. Score: #{person.score}"
    puts "Dealer's cards are: #{computer.hand}. Score: #{computer.score}"
  end

  def display_player_turn_message
    puts ""
    puts " -Your turn-"
  end

  def display_computer_turn_message
    puts ""
    puts " -Dealer's turn- "
  end
    
  def display_dealt_card(player)
    sleep(0.5)
    if player == @computer
      puts "Dealer received a #{@computer.hand.last}."
    else
      puts "You received a #{@person.hand.last}."
    end
  end

  def display_winner
    puts ""
    puts " -Final score-"
    display_all_cards
    if person.score > 21
      puts "You have #{person.score} - Bust. You lose."
    elsif computer.score > 21
      puts "Dealer busted, you win!"
    elsif person.score > computer.score
      puts "You win!"
    elsif computer.score > person.score
      puts "Dealer wins."
    else
      puts "It's a tie!"
    end      
  end

  def display_endgame_message
    puts ""
    puts "Thanks for playing!"
  end

  def deal_to(player)
    if player == person
      person.add_card_to_hand(deck.deal_one_card)
    else
      computer.add_card_to_hand(deck.deal_one_card)
    end
  end

  def deal_initial_cards
    2.times do
      [person, computer].each { |player| deal_to(player) }
    end
  end

  def check_for_blackjack
    if person.score == 21
      puts "21, you win!"
    elsif computer.score == 21
      puts "Dealer got 21!"
    end
  end

  def ask_player_to_hit
    puts "Do you want to hit? (y/n)"
    hit = gets.chomp
    until ["y", "n"].include?(hit.downcase)
      puts "Do you want another card? Please type 'y' or 'n'."
      hit = gets.chomp
    end
    hit
  end

  def player_turn
    display_player_turn_message
    begin
      display_initial_cards
      return nil if computer.score == 21
      hit = ask_player_to_hit
      break if hit == "n"
      deal_to(person)
      display_dealt_card(person)
    end while person.score <= 21
    puts "You stay on #{person.score}"
  end

  def dealer_turn
    display_computer_turn_message
    return nil if person.score > 21
    while computer.score < 17
      deal_to(computer)
      display_dealt_card(computer)
    end
    puts "Dealer stays on #{computer.score}"
  end

  def ask_play_again
    puts ""
    puts "Do you want to play again? (y/n)"
    play_again = gets.chomp.downcase
  end

  def play_again
    play_again = ask_play_again
    begin
      if play_again == 'y'
        start_new_game
      elsif play_again == 'n'
        exit_game
      else
        play_again = ask_play_again
      end
    end while ['y', 'n'].include?(play_again)
  end

  def start_new_game
    @deck = Deck.new
    @person.hand = []
    @person.score = 0
    @computer.hand = []
    @computer.score = 0
    run
  end

  def exit_game
    display_endgame_message
    exit
  end

  def run
    clear_screen
    display_welcome_message
    deal_initial_cards
    check_for_blackjack
    player_turn
    dealer_turn
    display_winner
    play_again
  end
end

Game.new.run
