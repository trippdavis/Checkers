class Piece
  attr_accessor :king
  attr_reader :color

  def initialize(pos, color)
    @pos, @color = pos, color
    @king = false
  end

  def symbol
    if king?

    else
      "\u25CF".encode('utf-8').colorize(color)
    end
  end

  def king?
    king
  end
end
