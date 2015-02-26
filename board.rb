require_relative 'piece.rb'
require 'colorize'
require 'byebug'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    populate_board
    display
  end

  def [](x, y)
    grid[x][y]
  end

  def []=(x, y, piece)
    self.grid[x][y] = piece
  end


  def populate_board
    starting_pos = [0,2,4,6]
    starting_rows = [0,1,2,5,6,7]
    starting_rows.each do |row|
      row_adder = row % 2
      color = (row > 2) ? :white : :black
      starting_pos.each do |pos|
        coords = [row, pos + row_adder]
        self[*coords] = Piece.new(coords, color)
      end
    end
  end

  def display
    puts render
  end

  def render
    str = ""
    grid.each_with_index do |row, row_i|
      row.each_with_index do |space, col_i|
        background = ((row_i + col_i) % 2 == 0) ? :red : :black
        space_str = space.nil? ? "   " : " #{space.symbol} "
        str << space_str.colorize(:background => background)
      end
      str << "\n"
    end

    str
  end
end
