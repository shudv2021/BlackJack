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
    print ' Введите имя новгого игрока:'
    @gamer = Player.new(gets.chomp)
    # this method get new Deck and clean players cards
    new_deal
  end

  # This method show current situation on the desk
  def show_desk
    system('clear')
    show_player(@dealer)
    show_player(@gamer)
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

  # There are logik of game
  def win?
    sleep(3)
    check_points
  end

  def check_points
    cast_draw if @gamer.hand.points? > 21 && @dealer.hand.points? > 21
    cast_win(@dealer) if @gamer.hand.points? > 21
    cast_win(@gamer) if @dealer.hand.points? > 21
    check_more_points if @gamer.hand.points? < 22 && @dealer.hand.points? < 22
  end

  def check_more_points
    cast_win(@gamer) if @gamer.hand.points? > @dealer.hand.points?
    cast_win(@dealer) if @gamer.hand.points? < @dealer.hand.points?
    cast_draw if @gamer.hand.points? == @dealer.hand.points?
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

  def continuation?
    show_desk
    print ' Хотите продолжить? (1-да/2-нет):'
    chenge = gets.chomp
    chenge == '1' ? new_deal : game_over
    @game.game
  end

  def game_over
    system('clear')
    show_desk
    puts 'Результаты игры:'
    winer = 'Dealer'
    winer = @gamer.player_name if @gamer.player_bank > @dealer.player_bank
    puts "Со счетом #{@gamer.player_bank} / #{@dealer.player_bank} победил #{winer}!!!"
    sleep(3)
    exit
  end

  def step_by_gamer(choise)
    case choise
    when '1'
      puts 'Вы пропустили ход'
    when '2'
      @gamer.hand.add_card(@deck.hand_over)
      puts 'Вы взяли карту'
    when '3'
      win?
    end
  end

  def step_by_dealer
    # Dealer step
    if @dealer.hand.points? < 17
      @dealer.hand.add_card(@deck.hand_over)
      puts 'Дилер взял карту'
    end
    win? if @gamer.hand.cards_on_hand.size > 2 && @dealer.hand.cards_on_hand.size > 2
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
end

Interface.new
