def coin_changer(change)
	# Hash with coins we want returned, default 0, will add to this and return it at the end.
	your_change = {quarters: 0, dimes: 0, nickels: 0, pennies: 0}
	# Hash representing the value of each coin.
	coin_value = {quarters: 25, dimes: 10, nickels: 5, pennies: 1}
	

	#Iterates through each item in the hash with access to the key and value.
	#While loop as long as the value is less or equal to change input.
	#Add 1 to your_change current key for each while loop.
	#Subtract value from change every while loop.
	coin_value.each { |key, value| while value <= change
										your_change[key] += 1
										change = change - value
									end}

	your_change # Hash to be returned with values altered to represent number of each coin.
end


# Need function to convert hash to strings for sinatra to display I think.

def coins_to_string(change)
	coins = coin_changer(change)
	numbers = ''
	coins.each do |key, value|       
	     numbers << value.to_s + ' ' + key.to_s + ' '

	 
	end
	numbers
end