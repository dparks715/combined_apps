require 'sinatra'
require_relative 'coins.rb'
require_relative 'class_isbn.rb'
require_relative 'board_app.rb'
require_relative 'unbeatable_app.rb'
require_relative 'classes_app.rb'
require_relative 'hangman.rb'

enable :sessions

get '/' do
	erb :welcome
end

get '/name' do
	erb :name
end

post '/name' do
	name = params[:name_input]
	redirect '/age?name=' + name
end

get '/age' do
	name = params[:name]
	erb :age, :locals => {name: name}
end

post '/age' do
	name = params[:name_input]
	age = params[:age_input]
	redirect '/fav_num?age=' + age + '&name=' + name
end

get '/fav_num' do
	age = params[:age]
	name = params[:name]
	erb :fav_num, :locals => {name: name, age: age}
end

post '/fav_num' do
	age = params[:age].to_i
	name = params[:name]
	num1 = params[:num1_input].to_i
	num2 = params[:num2_input].to_i
	num3 = params[:num3_input].to_i
	sum = num1 + num2 + num3

	results = 'less than'
	if sum > age
		results = 'greater than'
	elsif sum == age
		results = 'equal to'
	else
		results
	end

	erb :final, :locals => {
		name: name,
		age: age,
		num1: num1,
		num2: num2,
		num3: num3,
		sum: sum,
		results: results
	}
end

get '/change_input' do

	erb :change_input, :locals => {results: '', message1: ''}

end

post '/coins' do

	coins = params[:change].to_i
	results = coins_to_string(coins)
	erb :change_input, :locals => {results: results, message1: 'Your change is: '}

end

get '/ISBN_input' do
	erb :ISBN_input, :locals => {:isbn_num => '',
										:results => '',
										:message1 => '',
										:message2 => ''}
end

post '/ISBN_num' do
	isbn_num = params[:isbn_input]
	results = check_valid_isbn?(isbn_num)

	erb :ISBN_input, :locals => {:isbn_num => isbn_num,
										:results => results,
										:message1 => ' is a ',
										:message2 => ' ISBN'}
end

get '/ttt_start' do
	
	session[:board] = Board.new
	erb :ttt_welcome, :locals => {board: session[:board]}

end

post '/select_players' do

	session[:player1_type] = params[:player1]
	session[:player2_type] = params[:player2]
	session[:human1] = 'no'
	session[:human2] = 'no'

	if session[:player1_type] == 'Human'
		session[:player1] = Human.new('X')
		session[:human1] = 'yes'

	elsif session[:player1_type] == 'Easy'
		session[:player1] = Sequential.new('X')

	elsif session[:player1_type] == 'Medium'
		session[:player1] = RandomAI.new('X')

	elsif session[:player1_type] == 'Impossible!'
		session[:player1] = UnbeatableAI.new('X')
	end

	if session[:player2_type] == 'Human'
		session[:player2] = Human.new('O')
		session[:human2] = 'yes'

	elsif session[:player2_type] == 'Easy'
		session[:player2] = Sequential.new('O')

	elsif session[:player2_type] == 'Medium'
		session[:player2] = RandomAI.new('O')

	elsif session[:player2_type] == 'Impossible!'
		session[:player2] = UnbeatableAI.new('O')
	end

	session[:active_player] = session[:player1]

	if session[:human1] == 'yes'
		redirect '/board'
	else
		redirect '/make_move'
	end
end

get '/board' do

	erb :main_board, :locals => {player1: session[:player1], player2: session[:player2], active_player: session[:active_player].marker, board: session[:board]}

end

get '/make_move' do
	move = session[:active_player].get_move(session[:board].ttt_board)
	session[:board].update_position(move, session[:active_player].marker)

	redirect '/check_game_state'

end

post '/human_move' do

	move = params[:choice].to_i - 1

	if session[:board].valid_position?(move)
		session[:board].update_position(move, session[:active_player].marker)
		redirect '/check_game_state'
	else
	 	redirect '/board'
	end

end

get '/check_game_state' do

	if session[:board].winner?(session[:active_player].marker)

		message = "#{session[:active_player].marker} is the winner!"

		erb :game_over, :locals => {board: session[:board], message: message}
		
	elsif session[:board].full_board?

		message = "The game is a tie!"
		
		erb :game_over, :locals => {board: session[:board], message: message}
		
	else
		if session[:active_player] == session[:player1]
			session[:active_player] = session[:player2]
		else
			session[:active_player] = session[:player1]
		end

		if session[:active_player] == session[:player1] && session[:human1] == 'yes' || session[:active_player] == session[:player2] && session[:human2] == 'yes'
			redirect '/board'
		else
			redirect '/make_move'
		end
	end

end

get '/clear_sessions' do

	session[:board] = nil
	session[:active_player] = nil
	session[:human1] = nil
	session[:human2] = nil
	session[:player1_type] = nil
	session[:player2_type] = nil

	redirect '/ttt_start'

end


get '/hangman_start' do

	erb :hm_welcome

end

post '/hm_players' do

	session[:p1] = params[:player1]
	session[:p2] = params[:player2]

	erb :hm_get_word, :locals => {p1: session[:p1], p2: session[:p2]}

end

post '/pregame' do
	session[:guess_word] = params[:guess_word]
	session[:hangman] = Hangman.new(session[:guess_word])
	if session[:hangman].valid_input? == false
		redirect '/invalid_word'
	end

	session[:length] = session[:hangman].correct_letters.count

	redirect '/hm_main_game'

end

get '/invalid_word' do

	erb :hm_invalid

end

get '/hm_main_game' do
	session[:correct_letters] = session[:hangman].correct_letters.join
	session[:wrong] = session[:hangman].wrong_count

	erb :hm_main_game, :locals => {p1: session[:p1], p2: session[:p2], guess_word: session[:guess_word], correct: session[:correct_letters], length: session[:length], wrong: session[:wrong]}

end

post '/make_guess' do
	session[:letter] = params[:letter]
	session[:hangman].guess_letter(session[:letter])

	if session[:hangman].wrong_count == 6

		message = 'Oh no, you lost. :('
		lose = true

		erb :hm_game_over, :locals => {lose: lose, message: message, word: session[:guess_word]}

	elsif session[:hangman].correct_letters.include?('_ ')

		redirect '/hm_main_game'

	else

		message = 'Congrats! You won!'
		lose = false

		erb :hm_game_over, :locals => {lose: lose, message: message, word: session[:guess_word]}

	end
end

get '/hm_clear_sessions' do

	session[:hangman] = nil
	session[:letter] = nil
	session[:correct_letters] = nil
	session[:wrong] = nil
	session[:guess_word] = nil
	session[:p1] = nil
	session[:p2] = nil
	session[:length] = nil

	redirect '/hangman_start'
end