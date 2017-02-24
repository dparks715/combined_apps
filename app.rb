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
end