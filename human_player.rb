class HumanPlayer
  attr_reader :name
  attr_accessor :color
  
  def initialize(name)
    @name = name
  end

  def play_turn
    puts "#{name}, what piece would you like to move? (e.g. 0 0)"
    begin
      from_pos = gets.chomp.split(" ").map{ |coord| Integer(coord) }
    rescue
      puts "Please enter two valid numbers (0 - 7), separated by a space"
      retry
    end

end
