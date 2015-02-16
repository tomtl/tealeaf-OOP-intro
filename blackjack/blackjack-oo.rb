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

  def initialize
    @cards = []
  end
end

class Card
  attr_reader :rank, :suit, :value

  def initialize (rank, suit, value)
    @rank = rank
    @suit = suit
    @value = value
  end
end

class Player
  attr_accessor :hand

  def initialize
    @hand = []
  end
end