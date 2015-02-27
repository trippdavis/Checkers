require_relative 'piece.rb'
require 'colorize'
require 'byebug'

class Board
  attr_accessor :grid

  def initialize( dup = false )
    @grid = Array.new(8) { Array.new(8) }
    populate_board unless dup
  end

  def [](y, x)
    grid[y][x]
  end

  def []=(y, x, piece)
    self.grid[y][x] = piece
  end

  def dup
    dup_board = Board.new(true)
    pieces.each do |piece|
      dup_board[*piece.pos] = Piece.new(dup_board, piece.pos, piece.color)
    end

    dup_board
  end

  def pieces
    grid.flatten.compact
  end

  def populate_board
    starting_pos = [0, 2, 4, 6]
    starting_rows = [0, 1, 6, 7]
    starting_rows.each do |row|
      row_adder = row % 2
      color = (row >= 2) ? :white : :black
      starting_pos.each do |pos|
        coords = [row, pos + row_adder]
        self[*coords] = Piece.new(self, coords, color)
      end
    end
  end

  def display
    puts render
  end

  def render
    str = ""
    grid.each_with_index do |row, row_i|
      str << "#{row_i} "
      row.each_with_index do |space, col_i|
        background = ((row_i + col_i) % 2 == 0) ? :red : :black
        space_str = space.nil? ? "   " : " #{space.symbol} "
        str << space_str.colorize(:background => background)
      end
      str << "\n"
    end
    str << "   0  1  2  3  4  5  6  7"
  end

  def inspect
    display
  end

  def on_board?(pos)
    pos.all? { |coord| coord >= 0 && coord <= 7 }
  end

end
