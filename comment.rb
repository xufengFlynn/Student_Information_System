require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/comment.db")

class Comment
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :content, String
  property :created_at, DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/comments' do
  @comments = Comment.all
  erb :comments
end

get '/comments/new' do
  @comment = Comment.new
  erb :new_comment
end

get '/comments/:id' do
  @comment = Comment.get(params[:id])
  if (Comment.get(params[:id]) == nil)
    @title = "not exist"
    erb :not_found
  else
    erb :comment_show
  end
end

post '/comments' do
  comment = Comment.create(params[:comment])
  redirect to("comments/#{comment.id}")
end

put '/comments/:id' do
  comment = Comment.get(params[:id])
  comment.update(params[:comment])
  redirect to("/comments/#{comment.id}")
end

delete '/comments/:id' do
  @in = session[:admin]
  redirect to('/login') unless @in
  Comment.get(params[:id]).destroy
  redirect to('/comments')
end