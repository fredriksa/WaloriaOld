class PriceGenerator
  #Calculates sell price for item
  def self.sell_price(item, subclass = true)
    buy_price(item, subclass)/5
  end

  #Calculates buy price for item
  def self.buy_price(item, subclass = true)
    basePrice = item.itemlevel * Quality.first(name: item.quality).base_mod * Slot.first(name: item.slot).base_mod

    if subclass 
      basePrice *= Subclass.first(name: item.subclass).price_mod
    # If we don't have a subclass it's a weapon
    else
      basePrice *= Slot.first(name: item.slot).price_mod
    end

    basePrice += rand(0..basePrice*0.20)
  end
end