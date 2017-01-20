# Load all models
Dir["./models/*.rb"].each {|model| require model}
Dir["./lib/*.rb"].each {|lib| require lib}

# Used during local development (on your own machine)
configure :development do

  puts "*******************"
  puts "* DEVELOPMENT ENV *"
  puts "*******************"

  # Enable logging to console
  DataMapper::Logger.new($stdout, :debug)

  # Use SQLite
  DataMapper.setup(:default, "sqlite:///#{Dir.pwd}/db/app-dev.sqlite")

  # Enable pretty printing of Slim-generated HTML (for debugging)
  Slim::Engine.set_options pretty: true, sort_attrs: false

end

# Used during production (on Heroku), when your application is 'live'
configure :production do

  puts "******************"
  puts "* PRODUCTION ENV *"
  puts "******************"

  # Use Postgresql
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

end

# Used when running tests (rake test:[acceptance|models|routes])
configure :test do

  # Use SQLite db in RAM (for speed & since we do not need to save data between test runs
  DataMapper.setup(:default, 'sqlite::memory:')

end

# Load the application
require_relative '../app'

# Check that all models and associations are ok
DataMapper.finalize