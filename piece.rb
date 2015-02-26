class Piece
  attr_accessor :king, :pos
  attr_reader :color, :board

  def initialize(board, pos, color)
    @board, @pos, @color = board, pos, color
    @king = false
  end

  def symbol
    if king?
      "♚".colorize(color)
    else
      "●".colorize(color)
    end
  end

  def king?
    king
  end

  def dir
    color == :black ? 1 : -1
  end

  def perform_moves!(move_sequence)
    if move_sequence.size == 1
      move = move_sequence[0]
      perform_jump(move) unless perform_slide(move)
    else
      move_sequence.each do |move|
        perform_jump(move)
        self.pos = move
      end
    end
  end

  def perform_slide(end_pos)
    if valid_sliding_moves.include?(end_pos)
      board[*pos] = nil
      board[*end_pos] = self
      pos = end_pos
      promote?
      true
    else
      false
    end
  end

  def valid_sliding_moves
    y, x = pos
    [[y + dir, x + 1], [y + dir, x - 1]].select do |move_pos|
      board.on_board?(move_pos) && board[*move_pos].nil?
    end
  end

  def perform_jump(end_pos)
    if valid_jumping_moves.include?(end_pos)
      board[*pos] = nil
      board[*end_pos] = self
      board[*jumped_space(pos, end_pos)] = nil
      pos = end_pos
      promote?
      true
    else
      raise InvalidMoveError
      false
    end
  end

  def valid_jumping_moves
    y, x = pos
    [[y + (2 * dir), x + 2], [y + (2 * dir), x - 2]].select do |move_pos|
      jumped_piece = board[*jumped_space(move_pos, pos)]
      board.on_board?(move_pos) && board[*move_pos].nil? &&
      jumped_piece && jumped_piece.color != color
    end

  end

  def jumped_space(start_pos, end_pos)
    [(start_pos[0] + end_pos[0]) / 2, (start_pos[1] + end_pos[1]) / 2]
  end

  def promote?
    @king = true if pos[0] == 0 || pos[0] == 7
  end

end
