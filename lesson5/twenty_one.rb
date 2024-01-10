=begin

Here is an overview of the game:
- Both participants are initially dealt 2 cards from a 52-card deck.
- The player takes the first turn, and can 'hit' or 'stay'.
- If the player busts, he loses. If he stays, it's the dealer's turn.
- The dealer must hit until his cards add up to at least 17.
- If both totals are equal, then it's a tie, and nobody wins.

Nouns: card, player, dealer, participant, deck, game, total
Verbs: deal, hit, stay, busts

Player
- hit
- stay
- busted?
- total
Dealer
- hit
- stay
- busted?
- total
- deal (should this be here, or in Deck)
Participant
Deck
- deal (should this be here, or in Dealer)
Card
Game
- start

=end

module Hand
  attr_accessor :hand

  def display_card_value
    hand.each { |card| print card.to_s == '10' ? "|10  | " : "|#{card}   | " }
    puts ''
    puts '|    | ' * hand.size
    hand.each { |card| print card.to_s == '10' ? "|  10| " : "|   #{card}| " }
    puts ''
  end

  def display_hand
    puts '+----+ ' * hand.size
    display_card_value
    puts '+----+ ' * hand.size
    puts ''
  end

  def total
    calculated_total = hand.map(&:point_value).sum
    ace_count = hand.count { |card| card.point_value == 11 }
    loop do
      break if calculated_total <= 21 || ace_count == 0
      calculated_total -= 10
      ace_count -= 1
    end
    calculated_total
  end
end

module Displayable
  def display_welcome_messages
    system 'clear'
    puts 'Welcome to 21!'
    player.choose_name
    puts ''
    puts "Welcome #{player.name}!"
  end

  def display_play_again_message
    system 'clear'
    puts "Let's play again!"
  end

  def display_goodbye_message
    puts 'Thanks for playing 21! Goodbye!'
  end
end

class Participant
  include Hand

  def initialize
    @hand = []
  end

  def hit(deck)
    card = deck.current_cards.sample
    deck.current_cards.delete(card)
    hand << card
  end

  def busted?
    total > 21
  end

  def won?(other_participant)
    total > other_participant.total && !busted?
  end
end

class Player < Participant
  attr_reader :name

  def choose_name
    puts 'What is your name?'
    loop do
      @name = gets.chomp
      break unless @name.strip.empty?
      puts 'Sorry, please enter a valid name.'
    end
    @name = @name.strip
  end

  def show_cards
    puts 'Your cards are:'
    display_hand
  end

  def display_result
    puts "Your total is #{total}."
    puts "Sorry, #{name}, you busted. Dealer wins!" if busted?
    puts ''
  end
end

class Dealer < Participant
  def show_first_card
    puts "The dealer's card is:"
    puts '+----+'
    puts hand[0].to_s == '10' ? "|10  | " : "|#{hand[0]}   | "
    puts '|    | '
    puts hand[0].to_s == '10' ? "|  10| " : "|   #{hand[0]}| "
    puts '+----+'
    puts ''
  end

  def show_cards
    puts "The dealer's cards are:"
    display_hand
  end

  def display_result
    puts "The dealer's total is #{total}."
    puts "The dealer busted! You won!" if busted?
    puts ''
  end
end

class Deck
  attr_reader :current_cards

  def initialize
    @current_cards = []
    Card::VALUES.each do |value|
      4.times { @current_cards << Card.new(value) }
    end
  end

  def deal(player)
    2.times do
      card = current_cards.sample
      current_cards.delete(card)
      player.hand << card
    end
  end
end

class Card
  VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  def point_value
    if %w(2 3 4 5 6 7 8 9).include?(@value)
      @value.to_i
    elsif %w(10 J Q K).include?(@value)
      10
    else
      11
    end
  end
end

class Game
  include Displayable

  attr_reader :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    display_welcome_messages
    main_game
    display_goodbye_message
  end

  private

  def reset
    player.hand = []
    dealer.hand = []
    @deck = Deck.new
  end

  def deal_cards
    deck.deal(player)
    deck.deal(dealer)
  end

  def show_initial_cards
    player.show_cards
    dealer.show_first_card
  end

  def hit_or_stay
    move_choice = nil
    puts 'Would you like to hit (h) or stay (s)?'
    loop do
      move_choice = gets.chomp.downcase
      break if %w(h s).include?(move_choice)
      puts "Invalid. Please enter 'h' or 's'."
    end
    move_choice
  end

  def player_turn
    loop do
      puts "Your total is #{player.total}."
      move_choice = hit_or_stay
      break if move_choice == 's'
      player.hit(deck)
      player.show_cards
      break if player.busted?
    end
    player.display_result
  end

  def dealer_turn
    dealer.show_cards
    until dealer.total >= 17
      puts "The dealer's total is #{dealer.total}. The dealer hits!"
      dealer.hit(deck)
      gets
      dealer.show_cards
    end
    dealer.display_result
  end

  def show_result
    if player.won?(dealer)
      puts "Congratulations, #{player.name}! You won!"
    elsif dealer.won?(player)
      puts "Sorry, #{player.name}, dealer won."
    else
      puts "It's a tie!"
    end
    puts ''
  end

  def play_again?
    answer = nil
    puts 'Would you like to play again? (y/n)'
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts 'Invalid. Please enter y or n.'
    end
    answer == 'y'
  end

  def main_game
    loop do
      reset
      deal_cards
      show_initial_cards
      player_turn
      dealer_turn unless player.busted?
      show_result unless player.busted? || dealer.busted?
      break unless play_again?
      display_play_again_message
    end
  end
end

Game.new.start
