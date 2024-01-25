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

module Displayable
  RULES = <<-MSG
  - The object of the game is to get as close to 21 without going over.
  - Number cards are worth their number value.
  - Face cards are worth 10.
  - Aces can be worth 1 or 11.
  - You will be playing against the dealer.
  - You and the dealer both are initially dealt 2 cards from a 52-card deck.
  - You will be able to see both of your cards, but only 1 of the dealer's.
  - You will take the first turn, and can 'hit' or 'stay'.
  - A 'hit' will get you another card, but if you bust, you lose.
  - If you stay, it then becomes the dealer's turn.
  - The dealer must hit until his cards add up to at least 17.
  - The player with the total closest to 21 is the winner.
  - If both totals are equal, then it's a tie, and nobody wins.
  - Press Enter when you're ready to start!
  MSG

  def display_welcome_messages
    system 'clear'
    puts 'Welcome to 21!'
  end

  def display_top_message
    system 'clear'
    puts top_message
  end

  def display_rules
    return unless show_rules?
    puts RULES
    gets
  end

  def display_card_value
    current_cards.each do |card|
      print card.to_s == '10' ? "|10  | " : "|#{card}   | "
    end
    puts
    puts '|    | ' * current_cards.size
    current_cards.each do |card|
      print card.to_s == '10' ? "|  10| " : "|   #{card}| "
    end
    puts
  end

  def display_cards
    puts '+----+ ' * current_cards.size
    display_card_value
    puts '+----+ ' * current_cards.size
    puts
  end

  def display_player_busted_message
    puts "Sorry, #{player.name}, you busted. Dealer wins!"
    puts
  end

  def display_dealer_result
    puts "The dealer's total is #{dealer.hand.total}."
    puts "The dealer busted! You won!" if dealer.busted?
    puts
  end

  def display_player_turn
    player.show_cards
    puts "Your total is #{player.hand.total}."
    puts
  end

  def display_result
    if player.won?(dealer)
      puts "Congratulations, #{player.name}! You won!"
    elsif dealer.won?(player)
      puts "Sorry, #{player.name}, dealer won."
    else
      puts "It's a tie!"
    end
    puts
  end

  def display_scores
    puts 'The current score is:'
    puts "#{player.name}: #{player.score}, Dealer: #{dealer.score}"
  end

  def display_goodbye_message
    puts 'Thanks for playing 21! Goodbye!'
  end
end

module Choosable
  def show_rules?
    puts 'Would you like to hear the rules of the game? (y/n)'
    answer = nil
    loop do
      answer = gets.chomp
      break if %w(y n).include?(answer)
      puts "Sorry, invalid answer. Please enter 'y' or 'n'"
    end
    answer == 'y'
  end

  def display_player_prompt
    puts "Your total is #{player.hand.total}."
    puts 'Would you like to hit (h) or stay (s)?' unless player.busted?
    puts
  end

  def hit_or_stay
    move_choice = nil
    loop do
      move_choice = gets.chomp.downcase
      break if %w(h s).include?(move_choice)
      puts "Invalid. Please enter 'h' or 's'."
    end
    move_choice
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
end

class Hand
  include Displayable

  attr_accessor :current_cards

  def initialize
    reset
  end

  def reset
    @current_cards = []
  end

  def total
    calculated_total = current_cards.map(&:point_value).sum
    ace_count = current_cards.count { |card| card.point_value == 11 }
    loop do
      break if calculated_total <= 21 || ace_count == 0
      calculated_total -= 10
      ace_count -= 1
    end
    calculated_total
  end

  def [](idx)
    current_cards[idx]
  end
end

class Participant
  attr_accessor :score, :hand

  def initialize
    @hand = Hand.new
    @score = 0
  end

  def busted?
    hand.total > 21
  end

  def hit(deck)
    card = deck.cards.sample
    deck.cards.delete(card)
    hand.current_cards << card
  end

  def won?(other_participant)
    hand.total > other_participant.hand.total && !busted?
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
    system 'clear'
    @name = @name.strip
  end

  def show_cards
    puts 'Your cards are:'
    hand.display_cards
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
    puts
  end

  def show_cards
    puts "The dealer's cards are:"
    hand.display_cards
  end
end

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    Card::VALUES.each do |value|
      4.times { @cards << Card.new(value) }
    end
  end

  def deal(player)
    2.times do
      card = cards.sample
      cards.delete(card)
      player.hand.current_cards << card
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
  include Displayable, Choosable

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def start
    display_welcome_messages
    player.choose_name
    @top_message = "Welcome #{player.name}!"
    display_top_message
    display_rules
    main_game
    display_goodbye_message
  end

  private

  attr_reader :player, :dealer, :deck

  attr_accessor :top_message

  def reset
    player.hand.reset
    dealer.hand.reset
    @deck = Deck.new
  end

  def deal_cards
    deck.deal(player)
    deck.deal(dealer)
  end

  def show_initial_cards
    display_top_message
    player.show_cards
    display_player_prompt
    dealer.show_first_card
  end

  def player_turn
    loop do
      move_choice = hit_or_stay
      break if move_choice == 's'
      player.hit(deck)
      show_initial_cards
      break if player.busted?
    end
    display_player_busted_message if player.busted?
  end

  def dealer_turn
    loop do
      display_top_message
      display_player_turn
      dealer.show_cards
      break if dealer.hand.total >= 17
      puts "The dealer's total is #{dealer.hand.total}. The dealer hits!"
      dealer.hit(deck)
      sleep 3
    end
    display_dealer_result
  end

  def increase_score
    if player.won?(dealer) || dealer.busted?
      player.score += 1
    elsif dealer.won?(player) || player.busted?
      dealer.score += 1
    end
  end

  def game_setup
    reset
    deal_cards
    show_initial_cards
  end

  def keep_score
    increase_score
    display_scores
  end

  def main_game
    loop do
      game_setup
      player_turn
      dealer_turn unless player.busted?
      display_result unless player.busted? || dealer.busted?
      keep_score
      break unless play_again?
      @top_message = "Let's play again!"
      system 'clear'
    end
  end
end

Game.new.start
