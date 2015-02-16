# blakcjack-oo.rb

# Tealeaf course 1, lesson 2
# Tom Lee, Feb 16, 2014

# Theres a player and a dealer. 
# Dealer deals cards to player and self.
# Player counts score and decides to hit or stay
# If hit, dealer deals more cards until player stays or busts
# If blackjack, player wins
# On stay, dealer hits if less than 17
# dealer stays when 17 or greater, dealer busts if over 21
# Winner is the higher hand if not busted

# classes
# Player
#   - @hand
#   add card to hand

# Deck
#   - @Remaining cards
#   Shuffle
#   deal card

# Card
#   @rank
#   @suit
#   @value

# Game
#   deal cards
#   calculate hand score
#     with Ace compensation
#   win condition (blackjack)
#   bust condition
#   hit (deal one card)
#   who is Winner


# Flow
#   Deal cards
#   calculate hand score
#   win/bust condition
#   player turn
#     ask hit/stay
#     if hit
#       deal card
#       check for bust
#       ask hit again
#   dealer turn
#     if < 17
#       deal card
#       check for bust
#       loop until >=17
#   who won

class Deck
  attr_accessor :cards

  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, "Jack", "Queen", "King", "Ace"]
  SUITS = ["Clubs", "Diamonds", "Hearts", "Spades"]
  VALUES = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9,
            "Jack" => 10, "Queen" => 10, "King" => 10, "Ace" => 11 }

  def initialize
    @card = build_deck
  end

  def build_deck
    @cards = []

    2.times do
      RANKS.each do |rank|
        SUITS.each do |suit|
          @cards << Card.new(rank, suit)
        end
      end
    end
  end

  def deal
    cards.pop(10)
  end

  def shuffle
    cards.shuffle
  end

  def deal
    cards.shuffle.pop
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
      @score = 0
      hand.each { |card| @score += card.value }
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

  def deal_initial_cards
    2.times do
      person.add_card_to_hand(deck.deal)
      computer.add_card_to_hand(deck.deal)
    end
  end

  def display_initial_cards
    puts "Your cards are: #{person.hand}. Score: #{person.score}"
    puts "Dealer's first card is #{computer.hand.first}"
  end

  def display_all_cards
    puts "Your cards are: #{person.hand}. Score: #{person.score}"
    puts "Dealer's cards are: #{computer.hand}. Score: #{computer.score}"
  end
    
  def display_winner
    display_all_cards
    if person.score > 21
      puts "#{person.score} - You busted, you lose."
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

  def check_for_blackjack
    if @person.score == 21
      puts "21, you win!"
    elsif @computer.score == 21
      puts "Dealer got 21!"
    end
  end

  def player_turn
    begin
      return nil if computer.score == 21
      puts "Do you want to hit? (y/n)"
      hit = gets.chomp.downcase
      break if hit == "n"
      person.add_card_to_hand(deck.deal)
      display_initial_cards
    end while person.score <= 21
  end

  def dealer_turn
    return nil if person.score > 21
    while computer.score < 17
      computer.add_card_to_hand(deck.deal)
      display_all_cards
    end
  end

  def run
    deal_initial_cards
    display_initial_cards
    check_for_blackjack
    player_turn
    dealer_turn
    display_winner
  end
end

Game.new.run
