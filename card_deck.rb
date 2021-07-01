require_relative 'card'
class CardDeck
  attr_accessor :card_deck
  CARDSUIT= ["\u2660", "\u2663","\u2665","\u2666"].freeze
  CARDVALUE = ["2","3","4","5","6","7","8","9","10","V","D","K","T"].freeze

  def initialize
    generate_deck
    shuffle_the_deck
  end
end

def generate_deck
  @card_deck = []
  CardDeck::CARDSUIT.each do |suit|
    CardDeck::CARDVALUE.each do |val|
      @card_deck << Card.new(val, suit)
    end
  end
end

def shuffle_the_deck
  100.times do
    self.card_deck << self.card_deck.sample
    self.card_deck.reverse!
    self.card_deck.uniq!
  end

  def hand_over
    card = self.card_deck[0]
    self.card_deck.delete(card)
    card
  end

end

