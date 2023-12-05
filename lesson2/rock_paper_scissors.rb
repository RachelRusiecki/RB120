=begin

- rock beats scissors
- scissors beats paper
- paper beats rock

If the players chose the same move, then it's a tie.

Nouns: player, move, rule
Verbs: choose, compare

Player
- choose
Move
Rule

- compare

=end

module Displayable
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp.strip
      break unless n.empty?
      puts 'Sorry, must enter a value.'
    end
    self.name = n
  end

  def display_choices
    puts 'Please choose Rock, Paper, Scissors, Lizard, or Spock:'
    puts 'r = rock'
    puts 'p = paper'
    puts 'sc = scissors'
    puts 'l = lizard'
    puts 'sp = spock'
  end

  def prompt_choose
    choice = nil
    loop do
      display_choices
      choice = gets.chomp.capitalize
      break if Move::VALUES.include?(choice)
      puts 'Sorry, invalid choice.'
    end
    choice
  end

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors, Lizard, Spock!'
    loop do
      puts 'How many rounds would you like to get to victory?'
      @grand_total = gets.chomp.to_i
      break if @grand_total > 0
      puts 'Sorry, invalid choice. Please enter a number greater than 0.'
    end
    puts "OK! First one to #{@grand_total} wins!"
  end

  def display_goodbye_message
    puts 'Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Goodbye!'
  end

  def display_scores
    puts "#{human.name}: #{human.score}; #{computer.name}: #{computer.score}"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif computer.move > human.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_grand_winner
    if human.score >= @grand_total
      puts 'Congratulations! You are the grand winner!'
    else
      puts 'Sorry, the computer is the grand winner.'
    end
    puts "Here are all your moves so far: #{human.history}"
    puts "Here are all #{computer.name}'s moves so far: #{computer.history}"
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts 'Sorry, must be y or n.'
    end
    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end
end

class Player
  attr_accessor :move, :name, :score

  def increase_score
    @score += 1
  end

  def record_move
    @history_of_moves << move
  end

  def history
    @history_of_moves.join(', ')
  end

  private

  def initialize
    set_name
    @score = 0
    @history_of_moves = []
  end
end

class Human < Player
  include Displayable

  def choose
    choice = prompt_choose
    self.move = Rock.new('Rock') if choice.start_with? 'R'
    self.move = Paper.new('Paper') if choice.start_with? 'P'
    self.move = Scissors.new('Scissors') if choice.start_with? 'Sc'
    self.move = Lizard.new('Lizard') if choice.start_with? 'L'
    self.move = Spock.new('Spock') if choice.start_with? 'Sp'
  end
end

class Computer < Player
  def choose
    computer_choice = list_of_choices.sample
    case computer_choice
    when 'Rock' then self.move = Rock.new(computer_choice)
    when 'Paper' then self.move = Paper.new(computer_choice)
    when 'Scissors' then self.move = Scissors.new(computer_choice)
    when 'Lizard' then self.move = Lizard.new(computer_choice)
    when 'Spock' then self.move = Spock.new(computer_choice)
    end
  end

  private

  def list_of_choices
    arr = []
    self.class::PROBABILITY.each do |move, num|
      num.times { arr << move }
    end
    arr
  end
end

class R2D2 < Computer
  private

  PROBABILITY = { 'Rock' => 1,
                  'Paper' => 0,
                  'Scissors' => 0,
                  'Lizard' => 0,
                  'Spock' => 0 }

  def set_name
    self.name = 'R2D2'
  end
end

class Hal < Computer
  private

  PROBABILITY = { 'Rock' => 1,
                  'Paper' => 0,
                  'Scissors' => 3,
                  'Lizard' => 2,
                  'Spock' => 2 }

  def set_name
    self.name = 'Hal'
  end
end

class Chappie < Computer
  private

  PROBABILITY = { 'Rock' => 1,
                  'Paper' => 1,
                  'Scissors' => 1,
                  'Lizard' => 1,
                  'Spock' => 1 }

  def set_name
    self.name = 'Chappie'
  end
end

class Sonny < Computer
  private

  PROBABILITY = { 'Rock' => 0,
                  'Paper' => 1,
                  'Scissors' => 1,
                  'Lizard' => 0,
                  'Spock' => 0 }

  def set_name
    self.name = 'Sonny'
  end
end

class Number5 < Computer
  private

  PROBABILITY = { 'Rock' => 1,
                  'Paper' => 1,
                  'Scissors' => 10,
                  'Lizard' => 10,
                  'Spock' => 20 }

  def set_name
    self.name = 'Number 5'
  end
end

class Move
  def >(other_move)
    self.class::WINNING_VALUES.include?(other_move.to_s)
  end

  def to_s
    @value
  end

  private

  VALUES = %w(Rock R Paper P Scissors Sc Lizard L Spock Sp)

  def initialize(value)
    @value = value
  end
end

class Rock < Move
  WINNING_VALUES = %w(Scissors Lizard)
end

class Paper < Move
  WINNING_VALUES = %w(Rock Spock)
end

class Scissors < Move
  WINNING_VALUES = %w(Paper Lizard)
end

class Lizard < Move
  WINNING_VALUES = %w(Paper Spock)
end

class Spock < Move
  WINNING_VALUES = %w(Rock Scissors)
end

# Game Orchestration Engine
class RPSGame
  include Displayable

  def play
    display_welcome_message
    loop do
      human.score = 0
      computer.score = 0
      main_game
      display_grand_winner
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  attr_accessor :human, :computer

  def initialize
    system 'clear'
    @human = Human.new
    computer_name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
    case computer_name
    when 'R2D2' then @computer = R2D2.new
    when 'Hal' then @computer = Hal.new
    when 'Chappie' then @computer = Chappie.new
    when 'Sonny' then @computer = Sonny.new
    when 'Number 5' then @computer = Number5.new
    end
  end

  def increase_scores
    human.increase_score if human.move > computer.move
    computer.increase_score if computer.move > human.move
  end

  def player_turn(player)
    player.choose
    player.record_move
  end

  def main_game
    loop do
      display_scores
      player_turn(human)
      player_turn(computer)
      display_moves
      display_winner
      increase_scores
      break if human.score == @grand_total || computer.score == @grand_total
    end
  end
end

RPSGame.new.play
