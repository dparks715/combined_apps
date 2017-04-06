class Board

	attr_accessor :ttt_board

	def initialize
		@ttt_board = *(1..9)
	end

	def update_position(position, marker)
		ttt_board[position] = marker
	end

	def valid_position?(position)

		if ttt_board[position] != 'X' && ttt_board[position] != 'O' && position.between?(0,8)
			true
		else
			false
		end
		
	end

	def valid_input?(input)
		
		if input.match(/[xXoO]/)
			true
		else
			false
		end
		
	end

	def full_board?
		if ttt_board.all? { |x| x.is_a?(String) }
			true
		else
			false
		end
	end

	def winner?(marker)

		#2D array of winning combos
		winners = [
			[0, 1, 2],
			[3, 4, 5],
			[6, 7, 8],
			[0, 3, 6],
			[1, 4, 7],
			[2, 5, 8],
			[0, 4, 8],
			[2, 4, 6]
		]

		#Set results to false by default.
		results = false

		#Nested loops.  Iterates over 'outer' array
		#Then iterates over each inner_array.
		#Uses the value from each number in the inner array as
		#an index position in ttt_board.
		#If there is a match, it adds to count. If count reaches
		#three, results get set to true because all 3 in a set matched.
		#Count is reset to 0 for every new inner array item
		#because it is outside the inner loop.
		winners.each do |inner_array|
			count = 0

			inner_array.each do |value|

				if ttt_board[value] == marker

					count += 1

					if count == 3

						results = true

					end
				end
			end
		end
		#Calls our results which is false by default.
		#Only true if a set of the three combos matches.
		results

	end


end