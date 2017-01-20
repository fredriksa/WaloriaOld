class Stat
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :cost, Float
  property :db_id, Integer
end