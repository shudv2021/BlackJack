class Player

  attr_reader :player_name
  attr_accessor :player_bank, :distr_on_hand


  def initialize(player_name, player_bank = 100)
    @player_name = player_name
    @player_bank = player_bank
    clear_distr
  end

  #this method calculate points
  def calculate_distribution_on_hand
    total_point = 0
    total_cards = []
    @distr_on_hand.each { |card| total_cards << card.value }
    total_cards.each { |simbol| simbol.to_i.zero?|| simbol.to_i == 1 ? total_point+=10 : total_point+=simbol.to_i }
    total_point -=9 if total_point > 21 && total_cards.include?('T')
    total_point
  end

  #add card in array of players card(distr_on_hand)
  def add_card(card)
    @distr_on_hand << card
  end

  def place_bet(bet)
    @player_bank -= bet
  end

  def get_bank(bank)
    @player_bank += bank
  end

  def clear_distr
    @distr_on_hand = []
  end

end