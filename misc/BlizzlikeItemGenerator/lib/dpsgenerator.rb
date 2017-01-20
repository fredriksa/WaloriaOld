class DPSGenerator
  @@variation = 0.10

  def self.generate(item)
    # Calclulates base DPS
    dps = Slot.first(name: item.slot).dps_mod  * item.itemlevel

    # Modified depending on quality
    dps *= Quality.first(name: item.quality).price_mod

    # Calculates DPS with a +- 10 variation (if @@variation == 0.20)
    dps *= rand((1-@@variation/2)..(1+@@variation/2))
    dps.ceil
  end
end