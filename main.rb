require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'
require 'dm-timestamps'
require './student'
require './comment'

get('/views/style.scss') { scss :style }

get '/' do
  @title = "home page"
  erb :home
end

get '/home' do
  @title = "home page"
  erb :home
end

get '/about' do
  @title = "about page"
  erb :about
end

get '/contact' do
  @title = "contact page"
  erb :contact
end

get '/video' do
  @title = "video page"
  erb :video
end

get '/login' do
  @title = "login page"
  erb :login
end

not_found do
  @title = "not found page"
  erb :not_found
end


