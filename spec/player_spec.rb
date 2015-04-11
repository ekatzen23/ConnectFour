require './spec_helper'

describe Player do

	before do
		@player1 = Player.new
	end
	
	describe '#new' do
		it 'creates an instance of Player' do
			expect(@player1).to be_an_instance_of Player
		end
	end
	
	describe '#get_name' do
		before do
		  @player2 = Player.new
	      def @player2.get_name; "James" end
		end
	
		it 'returns your name' do
		  expect(@player2.get_name).to eql("James")	
		end

		#it 'stores your name' do
		  #expect(@player2.name).to eql("James")
		#end
		
	end

end