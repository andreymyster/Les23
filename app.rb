require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


configure do
  enable :sessions

  # $db = get_db
  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'CREATE TABLE IF NOT EXISTS
    "Users"
    (
      "Id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "Name" VARCHAR,
      "Phone" VARCHAR,
      "Datestamp" VARCHAR,
      "Barber" VARCHAR,
      "Color" VARCHAR
    )'
  db.close
end

# def get_db
#   return SQLite3::Database.new 'barbershop.db'
# end


def set_error hh
  @error = hh.select { |key,_| params[key] == ''}.values.join(', ')
end

get '/' do
  erb :index
end

get '/about' do
  @error = "Что-то пошло не так!"
  erb :about
end

get '/visit' do
  erb :visit
end

get '/contacts' do
  erb :contacts
end

post '/visit' do
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @barber = params[:barber]
  @color = params[:color]

  hh = { :username => 'Введите имя', :phone => 'Введите телефон', :datetime => 'введите дату и время' }
  set_error hh
  if @error != ''
    return erb :visit
  end

  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'insert into Users (name, phone, Datestamp, barber, color)
    values (?,?,?,?,?)', [@username, @phone, @datetime, @barber, @color]
  db.close

  erb "Спасибо за запись"
end

post '/contacts' do
  @email = params[:email]
  @usermessage = params[:usermessage]

  hh = { :email => 'Введите адрес', :usermessage => 'Введите сообщение' }
  set_error hh
  if @error != ''
    return erb :contacts
  end

  f = File.open './public/contacts.txt', 'a'
  f.write "E-mail: #{@email}. Message: #{@usermessage}\n"
  f.close

  erb "Спасибо. Сообщение отправлено."
end


# ЛОГИН
#-------------------------


helpers do
  def username
    session[:identity] ? session[:identity] : 'Login'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
  pass = params['pass']
  if pass == 'secret'
    session[:identity] = params['username']
    where_user_came_from = session[:previous_url] || '/'
    redirect to where_user_came_from
  else
    @message = "Wrong password"
    erb :login_form
  end
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end
