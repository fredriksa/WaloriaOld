class Slot
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :db_id, Integer
  property :weapon, Boolean, :default => false
  property :base_mod, Float
  property :durability_base, Float
  property :durability_mod, Float

  #Used for weapon slots, price in copper per item level for item
  property :price_mod, Float, :default => 0.0

  #DPS per weapon itemlevel
  property :dps_mod, Float, :default => 0.0

  has n, :subclasses, :through => Resource

  def budget(quality_budget)
    (@base_mod * quality_budget).ceil
  end
end