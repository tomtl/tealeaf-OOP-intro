class Board

  WINNING_LINES =  [
    [1, 4, 7], [2, 5, 8], [3, 6, 9],  # verticals
    [1, 2, 3], [4, 5, 6], [7, 8, 9],  # horizontals
    [1, 5, 9], [3, 5, 7]              # diagonals
  ]

  def initialize
    @data = {}
    (1..9).each { |position| @data[position] = Square.new(' ') }
  end

  def draw
    puts "-------------"
    puts "| #{@data[1]} | #{@data[2]} | #{@data[3]} |"
    puts "-------------"
    puts "| #{@data[4]} | #{@data[5]} | #{@data[6]} |"
    puts "-------------"
    puts "| #{@data[7]} | #{@data[8]} | #{@data[9]} |"
    puts "-------------"
  end

  def all_squares_marked?
    empty_squares.size == 0
  end

  def empty_squares
    @data.select { |_, square| square.value == ' ' }.values
  end 
  
  def empty_positions
    @data.select { |_, square| square.empty? }.keys 
  end

  def player_positions(marker)
    @data.select { |_, square| square.value = marker }.keys
  end

  def mark_square(position, marker)
    @data[position].mark(marker)
  end

  def winning_condition(marker)
    WINNING_LINES.each do |combination|
      if (combination & player_positions(marker)) == combination
        return true
      else
        return false
      end
    end
  end

end


class Square
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def mark(marker)
    @value = marker
  end

  def occupied?
    @value != ' '
  end

  def empty?
    @value == ' '
  end

  def to_s
    @value
  end
end

class Player
  attr_reader :marker
  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class Game
  def initialize
    @board = Board.new
    @human = Player.new("Chris", "X")
    @computer = Player.new("R2D2", "O")
    @current_player = @human
  end

  def current_player_marks_square
    if @current_player = @human
      begin
        puts "Choose a position (1-9):"
        position = gets.chomp.to_i
      end until @board.empty_positions.include?(position)
    else
      position = @board.empty_positions.sample
    end
    @board.mark_square(position, @current_player.marker)
  end

  def current_player_win?
    @board.winning_condition?(@current_player.marker)
  end

  def alternate_player
    if @current_player == @human
      @current_player = @computer
    else 
      @current_player = @human
    end
  end

  def play
    @board.draw
    loop do
      current_player_marks_square
      @board.draw
      if current_player_win?
        puts "The winner is #{@current_player.name}!"
        break
      elsif @board.all_squares_marked?
        puts "It's a tie!"
        break
      else
        alternate_player
      end
    end
    puts "Bye!"
  end
end

Game.new.play