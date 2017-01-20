class ArmorGenerator
  def self.generate(item)
    # If the item has a subclass that does not use armor we return 0
    return 0 unless Subclass.first(name: item.subclass).armor 

    # Calculate the armor for the uncommon item's item level
    total_armor = item.itemlevel * Subclass.first(name: item.subclass).armor_mod

    # Modify armor to fit item slot
    total_armor = total_armor * Slot.first(name: item.slot).base_mod

    # Modify armor to match quality
    total_armor = total_armor * Quality.first(name: item.quality).base_mod

    # Randomize armor by 10%
    total_armor = total_armor * rand(0.95..1.05)

    total_armor.ceil
  end
end