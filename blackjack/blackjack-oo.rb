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

  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, "J", "Q", "K", "A"]
  SUITS = ["C", "D", "H", "S"]
  VALUES = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9,
            "J" => 10, "Q" => 10, "K" => 10, "A" => 11 }

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
    @cards.pop(10)
  end

  def shuffle
    @cards.shuffle
  end

  def deal
    @cards.shuffle.pop
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
    "#{rank}#{suit}"
  end
end

class Player
  attr_accessor :hand

  def initialize
    @hand = []
  end

  def add_card_to_hand(card)
    hand << card
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

  def run
    deal_initial_cards
    p person.hand
    p computer.hand
  end

end

Game.new.run

