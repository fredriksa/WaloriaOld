class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, :unique => true
  property :password, BCryptHash, :required => true
  property :uses, Integer, :default => 0

  belongs_to :rank

  # Authenticates the user
  def self.authenticate(username, password)
    user = User.first(:username => username)
    user && user.password == password
  end
end