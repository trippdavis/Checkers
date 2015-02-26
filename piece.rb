class Piece
  attr_accessor :king
  attr_reader :color, :board, :pos

  def initialize(board, pos, color)
    @board, @pos, @color = board, pos, color
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

  def valid_moves
    valid_sliding_moves + valid_jumping_moves
  end

  def dir
    color == :black ? 1 : -1
  end

  def valid_sliding_moves
    y, x = pos
    [[y + dir, x + 1], [y + dir, x - 1]].select do |move_pos|
      board.on_board?(move_pos) && board[*move_pos].nil?
    end
  end

  def valid_jumping_moves
    y, x = pos
    [[y + (2 * dir), x + 2], [y + (2 * dir), x - 2]].select do |move_pos|
      jumped_piece = board[(move_pos[0] + pos[0]) / 2,
                           (move_pos[1] + pos[1]) / 2]
      board.on_board?(move_pos) && board[*move_pos].nil? &&
      jumped_piece && jumped_piece.color != color
    end

  end

end
