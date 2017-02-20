require 'minitest/autorun'
require 'rack/test'
require_relative '../app.rb'

class TestApp < Minitest::Test
  include Rack::Test::Methods

  def app
  	PersonalDetailsApp
  end

  def test_ask_name_on_entry_page
   get '/'
   assert(last_response.ok?)
   assert(last_response.body.include?('Hello, what is your name?'))
   assert(last_response.body.include?('<input type="text" name="name_input">'))
   assert(last_response.body.include?('<form action="name" method="post">'))
   assert(last_response.body.include?('<input type="submit" name="Submit">'))
  end

  def test_post_to_name
  	post '/name', name_input: 'Dan'
  	follow_redirect!
  	assert(last_response.ok?)
  	assert(last_response.body.include?('Dan'))
  	
  end

  def test_get_age
  	get '/age?name=Dan'
  	assert(last_response.ok?)
  	assert(last_response.body.include?('Dan'))
  	assert(last_response.body.include?('<input type="number" name="age_input">'))
  	assert(last_response.body.include?('<form action="age" method="post">'))
  	assert(last_response.body.include?('<input type="submit" name="Submit">'))
  	
  end

  def test_post_to_age
  	post '/age', age_input: 30, name: 'Dan'
  	follow_redirect!
  	assert(last_response.ok?)
  	assert(last_response.body.include?('30'))

  end

end