class Player
  attr_accessor :name, :color
  
  def initialize
  end
  
  def get_name
    puts "What is your name?"
	@name = gets.chomp
  end
end