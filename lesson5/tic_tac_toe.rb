=begin

Tic Tac Toe is a 2-player board game played on a 3x3 grid. Players take turns.

Nouns: board, player, square, grid
Verbs: play, mark

Board
Square
Player
- mark
- play

=end

require 'pry'

module Displayable
  def display_welcome_messages
    clear
    puts 'Welcome to Tic Tac Toe!'
    puts 'First player to get 5 victories is the winner!'
  end

  def display_goodbye_message
    puts 'Thanks for playing Tic Tac Toe! Goodbye!'
  end

  def display_markers
    puts "#{human.name} is '#{human.marker}'"
    puts "#{computer.name} is '#{computer.marker}'"
  end

  def display_score
    puts 'Current Score ='
    puts "#{human.name}: #{human.score}; #{computer.name}: #{computer.score}"
  end

  def joinor(arr, delimiter = ', ', word = 'or')
    case arr.size
    when 0 then ''
    when 1 then arr[0].to_s
    when 2 then arr.join(" #{word} ")
    else
      "#{arr[0...-1].join(delimiter)}#{delimiter}#{word} #{arr[-1]}"
    end
  end

  def display_round_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker then puts 'You won!'
    when computer.marker then puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
    sleep 2
  end

  def display_game_result
    if human.score == 5
      puts 'Congrats! You are the winner!'
    else
      puts "Sorry! #{computer.name} won. Better luck next time!"
    end
  end

  def display_play_again_message
    puts "Lets's play again!"
    puts ''
    sleep 2
  end
end

module Promptable
  def prompt_name
    name = ''
    puts 'What is your name?'
    loop do
      name = gets.chomp
      puts ''
      break unless name.strip.empty?
      puts 'Sorry, must enter a name.'
    end
    name.strip
  end

  def prompt_marker
    marker = ''
    puts 'What would you like your marker to be?'
    loop do
      marker = gets.chomp
      puts ''
      break if marker.strip.size == 1
      puts 'Sorry, must enter a valid marker.'
    end
    marker.strip
  end

  def prompt_start_decision
    answer = ''
    loop do
      puts 'Would you like to decide who goes first? (y/n)'
      answer = gets.chomp.downcase
      puts ''
      break if %w(y n).include?(answer)
      puts 'Sorry, must be y or n'
    end
    answer
  end

  def prompt_first_player
    answer = ''
    loop do
      puts 'Who would you like to go first? Human (h) or Computer (c)?'
      answer = gets.chomp.downcase
      break if %w(c h).include?(answer)
      puts "Sorry, that's not a valid choice. Please enter 'h' or 'c'"
    end
    answer
  end

  def prompt_play_again
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts 'Sorry, must be y or n'
    end
    answer
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
                   [1, 4, 7], [2, 5, 8], [3, 6, 9], # cols
                   [1, 5, 9], [3, 5, 7]]            # diagonals

  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def [](key)
    squares[key]
  end

  def []=(key, marker)
    squares[key].marker = marker
  end

  def unmarked_keys
    squares.keys.select { |key| squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares_arr = squares.values_at(*line)
      if three_identical_markers?(squares_arr)
        return squares_arr.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| squares[key] = Square.new }
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :name
  attr_accessor :score, :marker

  def initialize
    @score = 0
  end
end

class Human < Player
  include Promptable

  def choose_name
    @name = prompt_name
  end

  def choose_marker
    @marker = prompt_marker
  end
end

class Computer < Player
  NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def choose_name
    @name = NAMES.sample
  end

  def choose_marker
    @marker = 'O'
  end
end

class TTTGame
  include Displayable, Promptable

  attr_reader :board, :human, :computer

  def play
    human.choose_name
    computer.choose_name
    human.choose_marker
    computer.choose_marker
    check_computer_marker
    assign_first_player
    main_game
    display_goodbye_message
  end

  private

  def initialize
    display_welcome_messages
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
  end

  def check_computer_marker
    computer.marker = 'X' if human.marker.upcase == 'O'
  end

  def decide_who_starts?
    return false unless prompt_start_decision == 'y'
    true
  end

  def assign_first_player
    if decide_who_starts?
      answer = prompt_first_player
      @first_player = answer == 'h' ? human.marker : computer.marker
    else
      @first_player = [human.marker, computer.marker].sample
    end
  end

  def clear
    system 'clear'
  end

  def display_board
    display_markers
    display_score
    puts ''
    board.draw
    puts ''
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}):"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    board[square] = human.marker
  end

  def find_at_risk_square(line, marker_type)
    square_arr = board.squares.values_at(*line)
    unless square_arr.collect(&:marker).count(marker_type) == 2
      return nil
    end
    at_risk = board.squares.select do |num, square|
      line.include?(num) && square.marker == Square::INITIAL_MARKER
    end
    at_risk.keys[0]
  end

  def scan_winning_lines(marker_type)
    marked_square = nil
    Board::WINNING_LINES.each do |line|
      marked_square = find_at_risk_square(line, marker_type)
      break if marked_square
    end
    marked_square
  end

  def offensive_move
    scan_winning_lines(computer.marker)
  end

  def defensive_move
    scan_winning_lines(human.marker)
  end

  def computer_moves
    marked_square = offensive_move
    marked_square = defensive_move if !marked_square
    marked_square = 5 if !marked_square && board.squares[5].unmarked?
    marked_square = board.unmarked_keys.sample if !marked_square
    board[marked_square] = computer.marker
  end

  def increase_score
    human.score += 1 if board.winning_marker == human.marker
    computer.score += 1 if board.winning_marker == computer.marker
  end

  def play_again?
    prompt_play_again == 'y'
  end

  def current_player_moves
    human_turn? ? human_moves : computer_moves
  end

  def alternate_round_player
    @current_player = human_turn? ? computer.marker : human.marker
  end

  def alternate_first_player
    @first_player = if @first_player == human.marker
                      computer.marker
                    else
                      human.marker
                    end
  end

  def human_turn?
    @current_player == human.marker
  end

  def mark_moves
    loop do
      current_player_moves
      alternate_round_player
      break if board.someone_won? || board.full?
      clear_screen_and_display_board
    end
  end

  def reset
    board.reset
    alternate_first_player
    clear
  end

  def reset_score
    human.score = 0
    computer.score = 0
  end

  def play_round
    loop do
      clear_screen_and_display_board
      @current_player = @first_player
      mark_moves
      display_round_result
      increase_score
      break if human.score == 5 || computer.score == 5
      reset
    end
    clear
  end

  def main_game
    loop do
      play_round
      display_board
      display_game_result
      break unless play_again?
      reset
      reset_score
      display_play_again_message
      assign_first_player
    end
  end
end

game = TTTGame.new
game.play
