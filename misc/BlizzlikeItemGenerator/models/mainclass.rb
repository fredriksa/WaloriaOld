class Mainclass
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :db_id, Integer

  has n, :subclasses
end