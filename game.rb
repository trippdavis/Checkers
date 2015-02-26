require_relative 'board.rb'
require_relative 'human_player.rb'

class Game
  attr_accessor :current_player
  attr_reader :board, :player1, :player2

  def initialize(player1, player2)
    @player1 = player1
    @player1.color = :white
    @player2 = player2
    @player2.color = :black
    @current_player = player1
  end


  def play
    @board = Board.new
    until game_over?
      board.display
      current_player.play_turn
      switch_player
    end

  end

  def switch_player
    self.current_player = (self.current_player == player 1) ?
      player2 : player1
  end
end
