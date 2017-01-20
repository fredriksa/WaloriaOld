class Display
  include DataMapper::Resource

  property :id, Serial
  property :class_id, Integer
  property :subclass_id, Integer
  property :inventorytype, Integer
  property :requiredlevel, Integer
  property :displayid, Integer
end