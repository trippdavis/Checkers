require_relative 'board.rb'
require_relative 'human_player.rb'

class BadSelectionError < RuntimeError; end

class Checkers
  attr_accessor :current_player
  attr_reader :board, :player1, :player2

  def initialize
    @player1 = HumanPlayer.new("W")
    @player1.color = :white
    @player2 = HumanPlayer.new("B")
    @player2.color = :black
    @current_player = player1
  end


  def play
    @board = Board.new
    player1.help
    until game_over?
      board.display
      begin
        move_sequence = current_player.play_turn
        start_pos = move_sequence.shift
        piece = board[*start_pos]
        if piece.nil? || piece.color != current_player.color
          raise BadSelectionError
        end
        piece.perform_moves(move_sequence)
      rescue BadSelectionError
        puts "Please select one of your pieces (type 'h' for help)"
        retry
      rescue InvalidMoveError
        puts "Invalid move (type 'h' for help)"
        retry
      end

      switch_player
    end

  end

  def switch_player
    self.current_player = (self.current_player == player1) ?
      player2 : player1
  end

  def game_over?
    board.pieces.all? { |piece| piece.color == :white } ||
    board.pieces.all? { |piece| piece.color == :black }
  end
end
