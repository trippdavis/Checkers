class InvalidMoveError < RuntimeError; end

require 'byebug'

class Piece
  attr_accessor :king, :pos
  attr_reader :color, :board

  def initialize(board, pos, color, king = false)
    @board, @pos, @color = board, pos, color
    @king = king
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

  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError
    end
  end

  def valid_move_seq?(move_sequence)
    dup_board = board.dup
    dup_piece = Piece.new(dup_board, pos, color, king?)
    begin
      dup_piece.perform_moves!(move_sequence)
    rescue InvalidMoveError
      return false
    end

    true
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
      self.pos = end_pos
      promote?
      true
    else
      false
    end
  end

  def valid_sliding_moves
    y, x = pos
    valid_directions.each_with_object([]) do |direction, val_pos|
      move_pos = [y + direction[0], x + direction[1]]
      val_pos << move_pos if board.on_board?(move_pos) && board[*move_pos].nil?
    end
  end

  def perform_jump(end_pos)
    if valid_jumping_moves.include?(end_pos)
      board[*pos] = nil
      board[*end_pos] = self
      board[*jumped_space(end_pos)] = nil
      self.pos = end_pos
      promote?
      true
    else
      raise InvalidMoveError
      false
    end
  end

  def valid_jumping_moves
    y, x = pos
    valid_directions.each_with_object([]) do |direction, val_pos|
      move_pos = [y + 2 * direction[0], x + 2 * direction[1]]
      jumped_space = jumped_space(move_pos)
      next unless board.on_board?(jumped_space)
      jumped_piece = board[*jumped_space]
      if board.on_board?(move_pos) && board[*move_pos].nil? &&
      jumped_piece && jumped_piece.color != color
        val_pos << move_pos
      end
    end
  end

  def jumped_space(end_pos)
    [(pos[0] + end_pos[0]) / 2, (pos[1] + end_pos[1]) / 2]
  end

  def promote?
    self.king = true if pos[0] == 0 || pos[0] == 7
  end

  def valid_directions
    directions = [[dir, 1], [dir, -1]]
    (directions += [[-1 * dir, 1], [-1 * dir, -1]]) if king?
    directions
  end

end
