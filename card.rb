# frozen_string_literal: true

class Card
  attr_accessor :value, :suit

  CARDSUIT = ["\u2660", "\u2663", "\u2665", "\u2666"].freeze
  CARDVALUE = %w[2 3 4 5 6 7 8 9 10 V D K T].freeze

  def initialize(value, suit)
    @value = value
    @suit = suit
  end
end
