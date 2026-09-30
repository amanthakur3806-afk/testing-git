require 'sinatra'
require 'bcrypt'

# Enable sessions so we can track if a user is logged in
enable :sessions
set :session_secret, 'super_secret_key_change_me' # Secure random key in production

# Mock Database: In a real app, you would fetch this from SQLite, PostgreSQL, etc.
# The password shown here is the hashed version of "password123"
MOCK_DATABASE = {
  username: "admin",
  password_hash: BCrypt::Password.create("password123")
}

# 1. GET: Render the login page
get '/login' do
  erb :login
end

# 2. POST: Process the login form submission
post '/login' do
  username = params[:username]
  password = params[:password]

  # Find user and verify password
  if username == MOCK_DATABASE[:username] && BCrypt::Password.new(MOCK_DATABASE[:password_hash]) == password
    # Success! Store the user identifier in the session cookie
    session[:user] = username
    redirect '/dashboard'
  else
    # Failure: Reload login page with an error
    @error = "Invalid username or password."
    erb :login
  end
end

# 3. GET: A protected page that requires logging in
get '/dashboard' do
  if session[:user]
    @username = session[:user]
    erb :dashboard
  else
    # Redirect to login if trying to access dashboard while logged out
    redirect '/login'
  end
end

# 4. GET: Log out and clear the session
get '/logout' do
  session.clear
  redirect '/login'
end
