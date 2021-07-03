# frozen_string_literal: true

require_relative 'player'
require_relative 'card_deck'
require_relative 'hand'
require 'byebug'

class Game
  def initialize(game)
    @game = game
    # create Dealer
    @dealer = Player.new('Dealer')
    # create player
    @gamer = Player.new(@game.input_name)
    # this method get new Deck and clean players cards
    new_deal
  end

  # This method show current situation on the desk
  def show_desk
    system('clear')
    @game.show_player(@dealer)
    @game.show_player(@gamer)
  end

  # There are logik of game
  def win?
    sleep(3)
    check_points
  end

  def check_points
    @game.cast_draw if @gamer.hand.points? > 21 && @dealer.hand.points? > 21
    @game.cast_win(@dealer) if @gamer.hand.points? > 21
    @game.cast_win(@gamer) if @dealer.hand.points? > 21
    check_more_points if @gamer.hand.points? < 22 && @dealer.hand.points? < 22
  end

  def check_more_points
    @game.cast_win(@gamer) if @gamer.hand.points? > @dealer.hand.points?
    @game.cast_win(@dealer) if @gamer.hand.points? < @dealer.hand.points?
    @game.cast_draw if @gamer.hand.points? == @dealer.hand.points?
  end

  def new_deal
    # Create the players deck
    @deck = CardDeck.new
    # Each player get the two starts cards from the decK
    @dealer.hand.clear_distribution
    2.times { @dealer.hand.add_card(@deck.hand_over) }
    @dealer.place_bet(10)
    @gamer.hand.clear_distribution
    2.times { @gamer.hand.add_card(@deck.hand_over) }
    @gamer.place_bet(10)
  end

  def step_by_gamer(choise)
    case choise
    when '2'
      @gamer.hand.add_card(@deck.hand_over)
    when '3'
      win?
    end
  end

  def step_by_dealer
    # Dealer step
    @dealer.hand.add_card(@deck.hand_over) if @dealer.hand.points? < 17
    win? if @gamer.hand.cards_on_hand.size > 2 && @dealer.hand.cards_on_hand.size > 2
  end

  def game_over_result
    winer = 'Dealer'
    winer = @gamer.player_name if @gamer.player_bank > @dealer.player_bank
    [winer, @gamer.player_bank, @dealer.player_bank]
  end
end

class Interface
  def initialize
    @game = Game.new(self)
    game
  end

  def game
    loop do
      @game.show_desk
      print 'Выберите действие 1.Пропустить/2.Взять карту/3.Открыться: '
      choise = gets.chomp
      @game.step_by_gamer(choise)
      @game.step_by_dealer
    end
  end

  def input_name
    print ' Введите имя новгого игрока:'
    gets.chop
  end

  def show_player(player)
    puts "Игрок: #{player.player_name}"
    puts "Всего денег: #{player.player_bank}"
    if player.player_name != 'Dealr'
      print 'Раздача:'
      player.hand.cards_on_hand.each { |card| print "|#{card.value}#{card.suit}|" }
      puts "Очков в раздаче: #{player.hand.points?}"
    else
      player.hand.cards_on_hand.each { |_card| print '|*|' }
      puts 'Очков в раздаче: ***'
    end
    puts '*********************************************'
  end

  def continuation?
    @game.show_desk
    print ' Хотите продолжить? (1-да/2-нет):'
    chenge = gets.chomp
    @game.new_deal if chenge == '1'
    game_over(@game.game_over_result) if chenge != '1'

    game
  end

  def cast_win(player)
    # byebug
    puts "Выиграл #{player.player_name}"
    player.get_bank(20)
    continuation?
  end

  def cast_draw
    puts 'Ничья'
    @dealer.get_bank(10)
    @gamer.get_bank(10)
    continuation?
  end

  def game_over(result)
    system('clear')
    @game.show_desk
    puts 'Результаты игры:'
    puts "Со счетом #{result[1]} / #{result[2]} победил #{result[0]}!!!"
    sleep(3)
    exit
  end
end

Interface.new
