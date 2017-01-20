class Rank
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :users
end