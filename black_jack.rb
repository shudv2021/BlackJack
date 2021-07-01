require_relative 'player'
require_relative 'card_deck'

class Game
@deck = CardDeck.new
@dealer = nil
@gamer = nil

#This method show current situation on the desk
def show_desk
  system('clear')
  show_player(@dealer)
  show_player(@gamer)
end

def show_player(player)
  puts "Игрок: #{player.player_name}"
  puts "Всего денег: #{player.player_bank}"
  if player.player_name != 'Dealr'
  player.distr_on_hand.each { |card| print "|#{card.value}#{card.suit}|"}
  puts "Очков в раздаче: #{player.calculate_distribution_on_hand}"
  else
  player.distr_on_hand.each { |card| print "|*|"}
  puts "Очков в раздаче: ***"
  end
  puts '*********************************************'
end

#There are logik of game
def win?
  show_desk
  sleep(3)
  check_points
end

def check_points
  cast_draw if @gamer.calculate_distribution_on_hand > 21 && @dealer.calculate_distribution_on_hand > 21
  cast_win(@dealer) if @gamer.calculate_distribution_on_hand > 21
  cast_win(@gamer) if @dealer.calculate_distribution_on_hand > 21
  check_more_points if @gamer.calculate_distribution_on_hand < 22 && @dealer.calculate_distribution_on_hand < 22
end

def check_more_points
  cast_win(@gamer) if @gamer.calculate_distribution_on_hand > @dealer.calculate_distribution_on_hand
  cast_win(@dealer) if @gamer.calculate_distribution_on_hand < @dealer.calculate_distribution_on_hand
  cast_draw if @gamer.calculate_distribution_on_hand == @dealer.calculate_distribution_on_hand
end

def cast_win(player)
  puts "Выиграл #{player.player_name}"
  player.get_bank(20)
  continuation?
end

def cast_draw
  puts "Ничья"
  @dealer.get_bank(10)
  @gamer.get_bank(10)
  continuation?
end

def new_deal
#Create the players deck
@deck = CardDeck.new
#Each player get the two starts cards from the decK
@dealer.clear_distr
2.times { @dealer.add_card(@deck.hand_over) }
@dealer.place_bet(10)
@gamer.clear_distr
2.times { @gamer.add_card(@deck.hand_over) }
@gamer.place_bet(10)
end

def continuation?
  print " Хотите продолжить игру? (1-да/2-нет):"
  chenge = gets.chomp
  if chenge == '1' then new_deal else game_over end
end

def game_over
  system('clear')
  puts "Результаты игры:"
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
    @gamer.add_card(@deck.hand_over)
    puts 'Вы взяли карту'
  when '3'
    win?
  end
end

def step_by_dealer
  #Dealer step
  if @dealer.calculate_distribution_on_hand < 17
    @dealer.add_card(@deck.hand_over)
    puts "Дилер взял карту"
  end
end

def start_new
#create Dealer
@dealer = Player.new('Dealer')
#create player
print ' Введите имя новгого игрока:'
@gamer = Player.new(gets.chomp)
#this method get new Deck and clean players cards
interface
end

def interface
    show_desk
    continuation?
    print 'Выберите действие 1.Пропустить/2.Взять карту/3.Открыться: '
    choise = gets.chomp
    step_by_gamer(choise)
    sleep(1)
    step_by_dealer
    win? if @gamer.distr_on_hand.size > 2 && @dealer.distr_on_hand.size > 2
end

end

game = Game.new
game.start_new