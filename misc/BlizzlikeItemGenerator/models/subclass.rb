class Subclass
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :db_id, Integer
  property :sheath, Integer, :default => 0

  # Armor per itemlevel
  property :armor_mod, Float, :default => 0.0

  # Price in coppar per itemlevel
  property :price_mod, Float, :default => 0.0

  # Difference in durability in jump between slots. From leather to mail it's for instance +10
  property :next_mod, Float, :default => 0.0

  # Toggles whether the item should have armor or not
  property :armor, Boolean, :default => false

  property :onehanded, Boolean, :default => false
  property :twohanded, Boolean, :default => false
  property :ranged, Boolean, :default => false
  property :rangedmodrange, Integer, :default => 0
  property :ammotype, Integer, :default => 0

  property :speed_mod_min, Float, :default => 0.0
  property :speed_mod_max, Float, :default => 0.0

  belongs_to :mainclass
  has n, :slots, :through => Resource

  def name_suffix
    return "oneh" if @onehanded
    return "twoh" if @twohanded
    return "" if @ranged
  end
end