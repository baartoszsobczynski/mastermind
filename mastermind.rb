class Mastermind
  def initialize
    @code = []
    @colors = ["green", "blue", "yellow", "red", "black", "white"]
    @sockets = 4

    @allowed_guesses = 12
    @current_guess = []
    @all_guesses = []

    @red_indexes
    @current_feedback
    @previous_feedback
    @all_feedback = []
    @all_possible_codes = @colors.repeated_permutation(@sockets).to_a


    @won = false


    intro
    if select_role == 'maker'
      code_make
    else
      code_break
    end
  end

  def intro
    puts 'Welcome to..'
    puts "  /\\/\\   __ _ ___| |_ ___ _ __ _ __ ___ (_)_ __   __| |
 /    \\ / _` / __| __/ _ \\ '__| '_ ` _ \\| | '_ \\ / _` |
/ /\\/\\ \\ (_| \\__ \\ ||  __/ |  | | | | | | | | | | (_| |
\\/    \\/\\__,_|___/\\__\\___|_|  |_| |_| |_|_|_| |_|\\__,_|"

    puts "\nDo you know how to play?"
    player_know = gets.chomp.downcase
    until player_know == 'yes' || player_know == 'no'
      puts 'DO you know how to play? Answer \"yes\" or \"no\"'
      player_know = gets.chomp.downcase
    end
    introduce_player if player_know == 'no'
  end

  def introduce_player
    puts '\nMaster Mind is a code-breaking game for two players.  One player (code maker) creates a secret code
using colored pegs (black, white, red, yellow, green or blue) in four different slots.  The
colors and their exact order constitute the code. The other player (code breaker) has twelve
attempts to guess the secret code.  After each guess the code maker will give feedback on the
most recent guess.  The code maker will tell the code breaker whether or not their guess contained
a correct color in the correct slot (red peg for each one) and whether or not their guess contained
a correct color in the incorrect slot (white peg for each one).  The feedback received doesn\'t indicate
which exact slots are correct, only that one or more of your guess pegs includes an exact or near match.
Duplicate colors are permitted.  The code breaker only has twelve guesses!'
  end

  def select_role
    puts "\nDo you want to play breaker or maker?"
    role = gets.chomp.downcase
    until role == 'breaker' || role == 'maker'
      puts 'Choose \"breaker\" or \"maker\".'
      role = gets.chomp.downcase
    end
    role
  end

  def code_make
    puts "\nYou are playing as..."
    puts "/  __ \\         | |    |  \\/  |     | |
| /  \\/ ___   __| | ___| .  . | __ _| | _____ _ __
| |    / _ \\ / _` |/ _ \\ |\\/| |/ _` | |/ / _ \\ '__|
| \\__/\\ (_) | (_| |  __/ |  | | (_| |   <  __/ |
 \\____/\\___/ \\__,_|\\___\\_|  |_/\\__,_|_|\\_\\___|_|   "
    puts "You create code made up of four colors from: White, Black, Red, Blue, Yellow, Green"
    puts "Enter them separated by space."
    @code = request_user_code

    while @won == false && @allowed_guesses > 0
      play(computer_guess, "The computer")
    end
  end

  def request_user_code
    code = gets.chomp.downcase.split(' ')
    until code.length > 1
      puts "Enter four colors separated by spaces."
      code = gets.chomp.downcase.split(' ')
    end
    while !check_for_valid(code)
      puts "Your input is invalid. Put 4 colors separated by space"
      code = gets.chomp.downcase.split(' ')
    end
    code
  end

  def code_break
    puts "\nYou are playing as..."
    puts "/  __ \\         | |    | ___ \\              | |
| /  \\/ ___   __| | ___| |_/ /_ __ ___  __ _| | _____ _ __
| |    / _ \\ / _` |/ _ \\ ___ \\ '__/ _ \\/ _` | |/ / _ \\ '__|
| \\__/\\ (_) | (_| |  __/ |_/ / | |  __/ (_| |   <  __/ |
 \\____/\\___/ \\__,_|\\___\\____/|_|  \\___|\\__,_|_|\\_\\___|_|   "
    puts "\nYou have to guess the computer's code. Choose fours colors.
Duplicates are permitted. Colors: Green, Blue, Yellow, Red, Black, White.
Enter them in sequence, separated by space. For example: \"White Black Blue Blue\" \n"
    @code = generate_code
    while @won == false && @allowed_guesses > 0
      play(user_guess, 'You')
    end
  end

  def play(game_type, player_name)
    game_type
    generate_feedback(@current_guess, @code)
    @all_feedback << @current_feedback
    @previous_feedback = @current_feedback
    if player_name == 'You'
      display_board
    end
    check_for_win(@current_guess, player_name)
    unless @won
      @allowed_guesses -= 1
      if @allowed_guesses == 0
        puts "\n Secret code was #{@code}"
        puts "\n You lose"
      end
    end
  end

  def user_guess
    puts "\n You have #{@allowed_guesses} guesses. Try to guess!\n"
    guess = gets.chomp.downcase.split(" ")
    while !check_for_valid(guess)
      puts "Your input is invalid. Type #{@sockets} colors separated by space!"
      guess = gets.chomp.downcase.split(" ")
    end
    @current_guess = guess
    @all_guesses << @current_guess
  end

  def check_for_valid(guess)
    valid = true
    valid_colors = ["black", "white", "red", "yellow", "green", "blue"]
    guess.each do |guess|
      unless valid_colors.include?(guess)
        valid = false
      end
    end
    valid
  end

  def generate_feedback(guess, code)
    @current_feedback = []
    reds = count_reds(guess, code)
    whites = count_whites(guess, code)
    reds.times { @current_feedback << 'Red' }
    whites.times { @current_feedback << 'White' }
    @current_feedback
  end

  def count_reds(guess, code)
    @red_indexes = []
    count = 0
    guess.each_with_index do |socket, index|
      if socket == code[index]
        count += 1
        @red_indexes << index
      end
    end
    count
  end

  def count_whites(guess, code)
    count = 0
    temp_guess = []
    temp_code = []
    guess.each_with_index do |socket, index|
      if @red_indexes.include?(index)
        next
      end
      temp_guess << socket
      temp_code << code[index]
    end
    temp_guess.each do |socket|
      if temp_code.include?(socket)
        count += 1
        temp_code.delete_at(temp_code.index(socket))
      end
    end
    return count
  end

  def generate_code
    code = []
    @sockets.times do
      code << @colors.sample
    end
    code
  end

  def display_board
    counter = 1
    @all_guesses.each_with_index do |guess, index|
      print "\n" + "Guess # #{counter}: " + guess.to_s + "     Feedback: " + @all_feedback[index].to_s + "\n"
      counter += 1
    end
  end

  def check_for_win(guess, player_name)
    if guess == @code
      if player_name == 'You'
        puts "\nYou broke the code in #{13-@allowed_guesses} guesses. Nice!"
      elsif player_name == 'The computer'
        display_board
        puts "\n Computer broke the code in #{13-@allowed_guesses} guesses."
      end
      @won = true
    end
  end

  def computer_guess
    if @allowed_guesses == 12
      guess = random_initial_guess
    else
      remove_ineligible_guesses
      guess = @all_possible_codes.sample
    end
    @current_guess = guess
    @all_guesses << @current_guess
  end

  def remove_ineligible_guesses
    @all_possible_codes.reject! do |code|
      generate_feedback(code, @current_guess) != @previous_feedback
    end
  end

  def random_initial_guess
    colors = @colors.sample(2)
    guess = [colors[0], colors[0], colors[1], colors[1]]
    guess
  end
end


# main game loop below
play_again = 'yes'
while play_again == 'yes'
  Mastermind.new
  puts "\nDo you want to play again?"
  play_again = gets.chomp.downcase
end
