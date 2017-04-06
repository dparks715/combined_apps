class Hangman

	attr_accessor :word, :correct_letters, :wrong_count

	def initialize(word)
		@word = word.upcase
		@wrong_count = 0
		@correct_letters = container
	end

	#function to make a container array for guessed letters
	def container
		container = Array.new(word.length, '_')
	end

	def guess_letter(letter)

		letter = letter.upcase

		if word.include?(letter)

			word.each_char.with_index do |val, pos|
				if val == letter
					@correct_letters[pos] = val
				end
			end
		else
			@wrong_count += 1
		end

	end

	def valid_input?
		if word.match(/[^a-zA-Z]/)
			false
		else
			true
		end
	end

end

