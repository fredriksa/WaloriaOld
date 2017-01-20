class Bond
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :db_id, Integer
end