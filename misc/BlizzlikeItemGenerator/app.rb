require 'rack-flash'

class App < Sinatra::Base
  enable :sessions
  use Rack::Flash

  get '/' do
    slim :index
  end

  get '/home' do
    redirect '/' unless session[:user_id]

    slim :home
  end

  get '/weapons/generate' do 
    redirect '/' unless session[:user_id]
    session[:slot_suffix] = "oneh"

    slim :weapongenerator
  end

  get '/items/generate' do 
    redirect '/' unless session[:user_id]

    slim :itemgenerator
  end

  get '/randomlist' do 
    redirect '/' unless session[:user_id]

    slim :randomlist
  end

  get '/stats' do 
    Stat.all.to_json
  end

  get '/items/stats' do
    Stat.all.to_json
  end

  get '/item/subclasses/:slot' do |slot|
    slot = Slot.first(name: slot)
    slot.subclasses.to_json
  end

  get '/weapons/stats' do 
    Stat.all.to_json
  end

  get '/subclasses/:slot' do |slot|
    if ["one-hand", "main-hand", "off-hand"].include? slot.downcase
      session[:slot_suffix] = "oneh"
      return Subclass.all(onehanded: true).to_json
    elsif ["bow", "gun and wand"].include? slot.downcase
      session[:slot_suffix] = ""
      return Subclass.all(ranged: true).to_json
    elsif slot.downcase == "two-hand"
      session[:slot_suffix] = "twoh"
      return Subclass.all(twohanded: true).to_json
    end
  end

  get '/itemset' do 
    redirect '/' unless session[:user_id]
    slim :itemset
  end

  get '/weaponset' do 
    redirect '/' unless session[:user_id]
    slim :weaponset
  end

  post '/login' do 
    if User.authenticate(params['username'], params['password'])
      session[:user_id] = User.first(username: params['username']).id
      redirect '/home'
    end

    redirect back
  end

  post '/weapons/generate' do 
    user = User.get(session[:user_id])
    redirect '/' unless user 

    errorChecker = ErrorChecker.new(params, user)
    if errorChecker.error? 
      flash[:error] = errorChecker.error
      redirect '/weapons/generate'
    end

    params["tokenilevel"] = ItemLevel.calculate(params)
    filename = WeaponGenerator.generate(params, session[:user_id])

    send_file filename, :filename => "merged_items.sql", :type => 'Application/octet-stream'
    
    File.delete(filename)
    redirect '/items/generate'
  end

  post '/items/generate' do
    user = User.get(session[:user_id])
    redirect '/' unless user

    errorChecker = ErrorChecker.new(params, user)
    if errorChecker.error? 
      flash[:error] = errorChecker.error
      redirect '/items/generate'
    end

    filename = ItemGenerator.generate(params, session[:user_id])

    send_file filename, :filename => "merged_items.sql", :type => 'Application/octet-stream'

    File.delete(filename)
    redirect '/items/generate'
  end

  post '/itemset/generate' do 
    user = User.get(session[:user_id])
    redirect '/' unless user
    filename = "./sql/merged_itemset_#{session[:user_id]}.sql"
    File.delete(filename) if File.exists?(filename)
    #Might have to write a ErrorChecker, will skip for now
    filename = Itemsetgenerator.generate(params, session[:user_id])
    send_file filename, :filename => "merged_items.sql", :type => 'Application/octet-stream'
    #Any code after send_file gets ignored
    redirect '/itemset'
  end

  post '/weaponset/generate' do 
    user = User.get(session[:user_id])
    redirect '/' unless user
    filename = "./sql/merged_weaponset_#{session[:user_id]}.sql"
    File.delete(filename) if File.exists?(filename)
    #Might have to write a ErrorChecker, will skip for now
    filename = Weaponsetgenerator.generate(params, session[:user_id])
    send_file filename, :filename => "merged_weapons.sql", :type => 'Application/octet-stream'
    #Any code after send_file gets ignored
    redirect '/itemset'
  end

end