# frozen_string_literal: true

class Player
  attr_reader :player_name
  attr_accessor :player_bank, :hand

  def initialize(player_name, player_bank = 100)
    @hand = Hand.new
    @player_name = player_name
    @player_bank = player_bank
  end

  def place_bet(bet)
    @player_bank -= bet
  end

  def get_bank(bank)
    @player_bank += bank
  end
end
