require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Student
  include DataMapper::Resource
  property :id, Serial
  property :lastname, String
  property :firstname, String
  property :studentId, String
  property :address, String
  property :birthday, Date
end

DataMapper.finalize
DataMapper.auto_upgrade!

configure do
  enable :sessions
  set :username, 'mary'
  set :password, '123'
end

post '/login' do
  if params[:username] == 'mary' && params[:password] == '123'
    session[:admin] = true
    redirect to('/home')
  else
    erb :login
  end
end

get '/logout' do
  session.clear
  redirect to('/login')
end

get '/students' do
  @students = Student.all
  @in = session[:admin]
  erb :students
end

get '/students/new' do
  @in = session[:admin]
  redirect to('/login') unless @in  # check if login status
  @student = Student.new
  erb :new_student
end

get '/students/:id' do
  @in = session[:admin]
  redirect to('/login') unless @in    # check if login status
  @student = Student.get(params[:id])
  erb :show_student
end

get '/students/:id/edit' do
  @in = session[:admin]
  redirect to('/login') unless @in    # check if login status
  @student = Student.get(params[:id])
  if (Student.get(params[:id]) == nil)
    @title = "not exist"
    erb :not_found
  else
    erb :student_edit
  end
end

post '/students' do
  student = Student.create(params[:student])
  redirect to("/students/#{student.id}")
end

put '/students/:id' do
  @in = session[:admin]
  redirect to('/login') unless @in  # check if login status
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
  @in = session[:admin]
  redirect to('/login') unless @in    # check if login status
  Student.get(params[:id]).destroy
  redirect to('/students')            # after deleting one student, direct to studnets page
end