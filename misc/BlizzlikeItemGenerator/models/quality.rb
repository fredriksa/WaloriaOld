class Quality
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :base_mod, Float
  property :price_mod, Float
  property :budget_mod, Float

  # Penalty used when calculating quality budget
  property :penalty, Float
  property :db_id, Integer

  def budget(itemlevel)
    (@base_mod * itemlevel - @penalty).ceil
  end
end