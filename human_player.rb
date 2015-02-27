class HelpError < RuntimeError; end

class HumanPlayer
  attr_reader :name
  attr_accessor :color

  def initialize(name)
    @name = name
  end

  def play_turn
    puts "#{name}, it is your move (type 'h' for help)"
    begin
      move_input = gets.chomp
      if move_input == 'h'
        raise HelpError
      end
      move_input = move_input.split("").select { |char| char =~ /[0-9]/ }
      raise InvalidMoveError if move_input.size < 4 || move_input.size.odd?
      move_input.map! { |dig| Integer(dig) }
      move_sequence = []
      until move_input.empty?
        move_sequence << [move_input.shift, move_input.shift]
      end
    rescue HelpError
      self.help
      retry
    rescue ArgumentError
      puts "Only enter integers (type 'h' for help)"
      retry
    end

    move_sequence
  end



  def help
    puts "To enter moves, type the coordinates of your desired piece separated
          by a space and separated from the coordinates of any position (or
          positions in the case of multiple jumps) by a comma"
  end

end
