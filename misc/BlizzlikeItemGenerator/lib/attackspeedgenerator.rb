class AttackspeedGenerator

  def self.generate(item)
    # Adds the subclass speed and slot modifier speed together
    subclass = nil
    if item.slot == "Two-Hand".to_sym
      subclass = Subclass.first(name: item.subclass, twohanded: true)
    elsif item.slot == "One-Hand".to_sym
      subclass = Subclass.first(name: item.subclass, onehanded: true)
    else
      subclass = Subclass.first(name: item.subclass)
    end

    speed = rand(subclass.speed_mod_min..subclass.speed_mod_max)
    # Multiply by thousand because TrinityCore saves attackspeed in MS (1.8 sec = 1800 MS)
    (speed * 1000).ceil
  end

end