# frozen_string_literal: true
class Hand
  attr_accessor :cards_on_hand

  def initialize
    clear_distribution
  end

  def add_card(card)
    @cards_on_hand << card
  end

  def points?
    total_points = 0
    val = []
    @cards_on_hand.each do |card|
      val << card.value
      total_points += card.value.to_i.zero? ? 10 : card.value.to_i
      total_points -= 9 if total_points > 21 && val.include?('T')
    end
    total_points
  end

  def total_cards?
    @cards_on_hand.size
  end

  def clear_distribution
    @cards_on_hand = []
  end
end
