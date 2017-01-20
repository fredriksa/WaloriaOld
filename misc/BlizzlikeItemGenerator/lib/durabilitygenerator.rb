class DurabilityGenerator

  # Difference in jump between slots. From leather to mail it's +10
  @@subclass_difference = [5, 5, 10, 10]
  @@subclass = {cloth: 0, leather: 1, mail: 2, plate: 3}

  def self.generate(item)
    # Calculates the durability for item's slot
    slot_durability = Slot.first(name: item.slot).durability_mod * Slot.first(name: item.slot).durability_base

    # Modified durability depending on item quality
    slot_durability *= Quality.first(name: item.quality).price_mod

    # Add difference for different subclasses
    slot_durability += Subclass.first(name: item.subclass).next_mod
    
    # Randomize durability by +-10%
    slot_durability = rand((slot_durability * 0.9)..(slot_durability * 1.1))

    # Round to nearest multiple of 5
    (slot_durability/5).round * 5
  end
end