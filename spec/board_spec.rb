require './spec_helper'

describe Board do

	before :each do
		@board = Board.new
	end
	
	describe '#new' do
		it 'creates an instance of Board' do
			expect(@board).to be_an_instance_of Board
		end
		
		it 'assigns values to the board instance variable' do
			expect(@board.board).to be_truthy
		end
	end
	
	describe '#board' do
	  it 'contains an array of 6 elements' do
	    expect(@board.board.size).to eq(6)
      end
		
	  describe 'a board element' do
	    it 'contains an array of 7 elements' do
		  expect(@board.board[0].size).to eq(7)
		end
		
		describe 'the base element of the board' do
		  it 'is a hash' do
		    expect(@board.board[0][0]).to be_an_instance_of Hash
		  end
		  
		  it 'has 3 elements' do
		    expect(@board.board[0][0].size).to eq(3)
		  end
		  
		  describe 'each hash' do
		    it 'has an element that is blank' do
			  expect(@board.board[0][0].has_key?(:bla)).to be true
			end
						
			it 'has an element that is red' do
			  expect(@board.board[0][0].has_key?(:red)).to be true
			end
						
			it 'has an element that is yellow' do
			  expect(@board.board[0][0].has_key?(:yel)).to be true
			end
		  end
		end
		
		def only_one_true?(values)
		  return true if values.count(true) == 1
		  false
		end
		
		describe 'each base element of the board' do
		  it 'has only one value that is true' do
			truths = []
			@board.board.each do |row| 
			  row.each do |column| 
				intersection = column.values
				truths << only_one_true?(intersection)
			  end
			end
			expect(truths.count(true)).to eq(truths.size)
		  end
		end	
	  end
	end
	
	describe '#display' do
	  it 'prints a visual representation of the board' do
	    @board.display
	  end
	end
	
	describe '#move' do
	  it 'takes two arguments' do
	    expect{@board.move()}.to raise_error ArgumentError
	  end
	  
	  it 'the first argument is numeric' do
	    expect{@board.move(:red, :red)}.to raise_error TypeError
	  end
	  
	  it 'the second argument is :yel or :red' do
	    expect{@board.move(1, 1)}.to raise_error ArgumentError
	    expect{@board.move(1, "red")}.to raise_error ArgumentError
		expect{@board.move(1, :yellow)}.to raise_error ArgumentError
	  end
		
	  it 'returns true if a move is successfully completed' do
		expect(@board.move(1,:red)).to be true			
	  end
		
	  it 'returns false if a move is not possible' do
		6.times{expect(@board.move(1,:red)).to be true}
		expect(@board.move(1,:red)).to be false
	  end
	end
	
	describe '#cell_check' do
	  it 'returns the true key of the cell' do
		expect(@board.cell_check).to eq(:bla)
	  end
	end
	
	describe '#find_contiguous_color' do
	  it 'takes a single argument that must be an array with 4 elements' do
		expect(@board.find_contiguous_color([:red,:yel,:red])).to eq("nothing")
	  end
		
	  it 'can find when four or more contiguous elements in an array are red' do
		expect(@board.find_contiguous_color([:red,:yel,:red,:red,:red,:red])).to eq("red")
	  end
		
	  it 'can find when four or more contiguous elements in an array are yellow' do 
		expect(@board.find_contiguous_color([:red,:yel,:yel,:yel,:yel,:red])).to eq("yellow")
	  end
	end
	
	describe '#convert_rows_to_arrays' do
      it 'returns an array of 6 elements' do
		rows = @board.convert_rows_to_arrays
		expect(rows.size).to eq(6)
	  end
		
	  describe 'element in array' do
		it 'has 7 elements' do
		  rows = @board.convert_rows_to_arrays			
		  expect(rows[0].size).to eq(7)
		end
	  end
	end
	
	describe '#convert_columns_to_arrays' do
	  it 'returns an array of 7 elements' do
		columns = @board.convert_columns_to_arrays
		expect(columns.size).to eq(7)
	  end
			
	  describe 'element in array' do
		it 'has 6 elements' do
		  columns = @board.convert_columns_to_arrays
		  expect(columns[0].size).to eq(6)
		end
	  end
	end
	
	describe '#convert_diagonols_to_arrays' do
      it 'returns an array with 24 elements' do
		diagonals = @board.convert_diagonals_to_arrays
		expect(diagonals.size).to eq(24)
	  end
	end
	
	describe '#find_win' do
	  it 'finds a winning condition in a row' do
	    x = 0
		4.times {@board.move(x,:red); x += 1}
		expect(@board.find_win).to eq("red")
	  end
		
	  it 'finds a winning condition in a column' do
		4.times {@board.move(0,:yel)}
		expect(@board.find_win).to eq("yellow")
	  end
		
	  it 'finds a winning condition in a diagonal' do
		@board.move(0,:red); @board.move(1,:yel)
		@board.move(1,:red); @board.move(2,:yel); @board.move(2,:red)
		@board.move(2,:red); @board.move(3,:yel); @board.move(3,:red); @board.move(3,:yel)
		@board.move(3,:red)
		expect(@board.find_win).to eq("red")
	  end
	end
end