class Board
  attr_accessor :board
  
  def initialize(start = [])
    @board = Array.new(6){Array.new(7){{:bla => true, :red => false, :yel => false}}}
  end
  
  def display
	puts ""
	puts "   ====================================="
	@board.each do |row|
	  print "   ="
	  row.each do |column|
		intersection = column.select{|k,v| v == true}
		print "[#{intersection.key(true)}]"
	  end
	  puts "="
	end
	puts "   ====================================="
    puts ""
  end
  
  def move(column, color, row = 5)
    color_enforcement(color)
	if row < 0
	  puts "Column is full."
	  return false
	elsif @board[row][column][:bla] == false
	  move(column, color, row-1)
	elsif @board[row][column][:bla] == true
	  @board[row][column][:bla] = false
	  @board[row][column][color] = true
	  return true
	end
  end
  
  def color_enforcement(color)
    raise ArgumentError, 'Argument is not :red or :yel' unless color == :red || color == :yel
  end
  
  def cell_check(row = 0, column = 0)
    cell = @board[row][column].key(true)
  end
  
  def find_contiguous_color(array)
	return "nothing" if array.size < 4
	four_array = array[0,4]
	return "red" if four_array.count(:red) == 4
	return "yellow" if four_array.count(:yel) == 4
	array.shift
	find_contiguous_color(array)
  end
  
  def convert_rows_to_arrays(rows = [], x = 0)
	return rows if x > 5
	row = []; y = 0
	7.times {row << cell_check(x,y); y += 1 }
	rows << row
	x += 1
	convert_rows_to_arrays(rows,x)
  end
  
  def convert_columns_to_arrays(columns =[], y = 0)
	return columns if y > 6
	column = []; x = 0
	6.times {column << cell_check(x,y); x += 1 }
	columns << column 
	y += 1
	convert_columns_to_arrays(columns,y)
  end
  
  # The four diagonals are split into quadrants: bottom left, bottom right, top left, top right
  # Each quadrant has an array, such that arr:=[[6 elem], [5 elem], [4 elem], [3 elem], [2 elem], [1 elem]]
  # --> Look at a Connect Four board for better visualization
  # This is why some counters in the code below increase (bottom to top iteration) and some counters decrease (top to bottom iteration)
  # Note: x == rows, y == columns. That means [1,0] is 2nd row, 1st column (this is reversed from [x,y] in mathematics)
  
  # Assume [0,0] is bottom left and [6,5] is top right:
  # Top left
  def convert_diagonals_to_arrays_part_1(diagonals = [], start = 0)
	return diagonals if diagonals.size == 6
	diagonal = []; x = start; y = 0			
	until x > 5
	  diagonal << cell_check(x,y)
	  x += 1; y += 1
	end
	diagonals << diagonal
	start += 1
	convert_diagonals_to_arrays_part_1(diagonals, start)
  end
  
  # Bottom right
  def convert_diagonals_to_arrays_part_2(diagonals = [], start = 1)
	return diagonals if diagonals.size == 6
	diagonal = []; x = 0; y = start			
	until y > 6
	  diagonal << cell_check(x,y)
	  x += 1; y += 1
	end
	diagonals << diagonal
	start += 1
	convert_diagonals_to_arrays_part_2(diagonals, start)
  end

  # Bottom Left
  def convert_diagonals_to_arrays_part_3(diagonals = [], start = 5)
	return diagonals if diagonals.size == 6
	diagonal = []; x = 0; y = start			
	until y < 0
	  diagonal << cell_check(x,y)
	  x += 1; y -= 1
	end
	diagonals << diagonal
	start -= 1
	convert_diagonals_to_arrays_part_3(diagonals, start)
  end
  
  # Top right
  def convert_diagonals_to_arrays_part_4(diagonals = [], start = 0)
	return diagonals if diagonals.size == 6
	diagonal = []; x = start; y = 6
	until x > 5
	  diagonal << cell_check(x,y)
	  x += 1; y -= 1
	end
	diagonals << diagonal
	start += 1
	convert_diagonals_to_arrays_part_4(diagonals, start)
  end
		
  def convert_diagonals_to_arrays
	diagonals = convert_diagonals_to_arrays_part_1
	diagonals2 = convert_diagonals_to_arrays_part_2
	diagonals3 = convert_diagonals_to_arrays_part_3
	diagonals4 = convert_diagonals_to_arrays_part_4
	diagonals + diagonals2 + diagonals3 + diagonals4
  end
  
  def find_win
	diagonals = convert_diagonals_to_arrays
	columns = convert_columns_to_arrays
	rows = convert_rows_to_arrays
	arrays = diagonals + columns + rows
	arrays.each do |array|
	  color = find_contiguous_color(array)
	  if color == "red" || color == "yellow"
		puts "#{color.capitalize} is the winner!"
		return color
	  end
	end
	"no winner"
  end
end