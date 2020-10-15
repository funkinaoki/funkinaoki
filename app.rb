require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'
require 'sinatra'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end

  def current_senmonka
    Senmonka.find_by(id: session[:senmonka])
  end

  def protected!
    unless authorized?
      response['WWW-Authenticate']= %(Basic realm="Restricted Area")
      throw(:halt, [401,"Not authorized\n"])
    end
  end

  def authorized?
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['chillle','Inupino2']
  end
end

get '/' do
  @questions = Question.all
  @comments = Comment.all
  @senmonkas = Senmonka.all
  @lists = List.all
  erb :index
end

get '/signup'do
  erb :sign_up
end

post '/signup' do
  user = User.create(
    name: params[:name],
    password: params[:password],
    password_confirmation: params[:password_confirmation]
  )
  if user.persisted?
    session[:user] = user.id
  end
  redirect '/'
end

get '/signin' do
  erb :sign_in
end

post '/signin' do
  @questions = Question.all
  user = User.find_by(name: params[:name])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect '/'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end

get '/question' do
  erb :question
end

post '/question' do
  current_user.questions.create(title: params[:title],context: params[:context])
  redirect '/'
end

get '/senmonkapage' do
  erb :senmonka
end

get '/senmonkasignin' do
  erb :senmonkasignin
end

get '/senmonkasignup' do
  erb :senmonkasignup
end

post '/senmonkasignin' do
 senmonka = Senmonka.find_by(name: params[:name])
  if senmonka && senmonka.authenticate(params[:password])
    session[:senmonka] = senmonka.id
  end
  redirect '/'
end

post '/senmonkasignup' do
senmonka = Senmonka.create(
    name: params[:name],
    password: params[:password],
    password_confirmation: params[:password_confirmation],
    career: params[:career]
  )
  if senmonka.persisted?
    session[:senmonka] = senmonka.id
  end
  redirect '/'
end

get '/senmonkasignout' do
  session[:senmonka] = nil
  redirect '/'
end

get '/comment' do
  @questions = Question.all
  erb :comment
end

post '/comment/:id' do
  current_senmonka.comments.create(
    comment_context: params[:context],
    question_id: params[:id]
  )
  redirect '/'
end

get '/mypage' do
  erb :mypage
end

get '/senmonkamypage' do
  erb :senmonkamypage
end

get '/admin' do
  protected!
  @senmonkas = Senmonka.all
  erb :admin
end

get '/senmonka/:id/acceptance' do
  senmonka=Senmonka.find(params[:id])
  senmonka.acceptance =!senmonka.acceptance
  senmonka.save
  redirect'/admin'
end

get '/senmonka/:id/reject' do
  senmonka=Senmonka.find(params[:id])
  senmonka.reject =!senmonka.reject
  senmonka.save
  redirect'/admin'
end

get '/comment/:id/best' do

end