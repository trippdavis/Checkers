require_relative 'board.rb'
require_relative 'human_player.rb'
require 'io/console'
require 'byebug'

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

  def curser
    @board = Board.new
    until game_over?
      puts "Select your start position"
      begin
        puts "\e[H\e[2J"
        board.display
        start_pos = move_curser.dup
        piece = board[*start_pos]
        if piece.nil? || piece.color != current_player.color
          raise BadSelectionError
        end
        end_pos = move_curser.dup
        piece.perform_moves([end_pos])
      rescue BadSelectionError
        puts "Please select one of your pieces (type 'h' for help)"
        retry
      rescue => e
        puts e
        retry
      end
      switch_player
    end
  end

  def move_curser
    loop do
      movement = STDIN.getch
      case movement
      when "w"
        @board.curser_pos[0] -= 1
      when "a"
        @board.curser_pos[1] -= 1
      when "s"
        @board.curser_pos[0] += 1
      when "d"
        @board.curser_pos[1] += 1
      else
        puts "\e[H\e[2J"
        board.display
        break
      end
      puts "\e[H\e[2J"
      board.display
    end

    board.curser_pos
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
      rescue
        puts "Invalid move (type 'h' for help)"
        retry
      end
      switch_player
      puts "\e[H\e[2J"
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



if __FILE__ == $PROGRAM_NAME
  game = Checkers.new
  game.curser
end
