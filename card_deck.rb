# frozen_string_literal: true

require_relative 'card'
# this class include methods which sould be done of card_table
class CardDeck
  attr_accessor :card_deck

  CARDSUIT = ["\u2660", "\u2663", "\u2665", "\u2666"].freeze
  CARDVALUE = %w[2 3 4 5 6 7 8 9 10 V D K T].freeze

  def initialize
    generate_deck
    shuffle_the_deck
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
      card_deck << card_deck.sample
      card_deck.reverse!
      card_deck.uniq!
    end
  end

  def hand_over
    card = @card_deck[0]
    @card_deck.delete(card)
    card
  end
end
