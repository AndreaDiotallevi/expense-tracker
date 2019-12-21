require "sinatra/base"
require "sinatra/activerecord"
require "sinatra/flash"

require "./lib/user"

class ExpenseTracker < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register Sinatra::Flash
  set :database_file, "config/database.yml"
  enable :sessions

  get "/" do
    erb :"index"
  end

  get "/users/new" do
    erb :"users/new"
  end
  
  post "/users" do
    if params[:"password"] == params[:"confirm-password"]
      user = User.create(first_name: params[:"first-name"], surname: params[:"surname"],
                        email: params[:"email"], password: params[:"password"])
      session[:user_id] = user.id
      redirect "/themes"
    else
      flash[:notice] = "Please enter two matching passwords"
      redirect "/users/new"
    end
  end

  get "/sessions/new" do
    erb :"sessions/new"
  end

  post "/sessions" do
    user = User.where(email: params[:"email"], password: params[:"password"]).first
    if user
      session[:user_id] = user.id
      redirect "/themes"
    else
      flash[:notice] = "Please check your email or password"
      redirect "/sessions/new"
    end
  end

  post "/sessions/destroy" do
    session.clear
    flash[:notice] = 'You have logged out'
    redirect "/"
  end

  get "/themes" do
    @user = User.find(session[:user_id])
    erb :"themes/index"
  end
  
  run! if app_file == $0
end
