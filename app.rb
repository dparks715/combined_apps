require 'sinatra'

class PersonalDetailsApp < Sinatra::Base
	get '/' do
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
		age = params[:age]
		name = params[:name]
		num1 = params[:num1]
		num2 = params[:num2]
		num3 = params[:num3]
		redirect '/final?name=' + name + '&age=' + age
	end

	get '/final' do
		name = params[:name]
		age = params[:age]
		"#{name} and #{age}"
		#erb :final, :locals => {name: name, age: age}	
	end

	# post '/final' do
	# 	name = params[:name]
	# 	age = params[:age]
	# end

end