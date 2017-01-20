class DamageGenerator

  def self.generate_min(item)
    generate_mid_damage(item) * 0.7
  end

  def self.generate_max(item)
    generate_mid_damage(item) * 1.3
  end

  private
  def self.generate_mid_damage(item)
    # formula 
    # DPS = middledamage/attackspeed
    # middledamage = DPS * attackspeed (S)

    # Divide attackspeed by 1000 since attackspeed is saved in MS not S
    item.dps * (item.attackspeed/1000.to_f)
  end

end