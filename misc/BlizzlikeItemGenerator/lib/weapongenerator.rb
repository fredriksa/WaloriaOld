class WeaponGenerator
  #generates weapon from selected params
  def self.generate(params, user_id, entry_modifier = nil)
    entry_modifier = 0 if not entry_modifier

    weapons = []
    weapons_to_create = params['amount'].to_i
    weapons_to_create.times do
      weapons << generate_weapon(params, entry_modifier)
      entry_modifier += 1
    end
    
    filename = "./sql/merged_weapons_#{user_id}_#{weapons.first.slot_id}_#{weapons.first.subclass_id}.sql"
    self.save_sql(weapons, filename, params)
    return filename
  end

  private
  def self.generate_weapon(params, entry_modifier)
    StatsGenerator.set_unavailable_rate params['unavailable'].to_f

    weapon = Weapon.new
    weapon.entry = params['id'].to_i + entry_modifier
    weapon.level = params['level'].to_i
    weapon.class = :weapon
    weapon.subclass = params['subclass'].to_sym
    weapon.quality = params['quality'].to_sym
    weapon.slot = params['slot'].to_sym
    weapon.display_id = Displayselector.select(params, false)
    weapon.bonding = params['bonding'].to_sym
    weapon.itemlevel = ItemLevel.calculate(params)
    weapon.sellprice = PriceGenerator.sell_price(weapon, false)
    weapon.buyprice = PriceGenerator.buy_price(weapon, false)
    weapon.durability = DurabilityGenerator.generate(weapon)

    weapon.dps = DPSGenerator.generate(weapon)
    weapon.attackspeed = AttackspeedGenerator.generate(weapon)
    weapon.min_damage = DamageGenerator.generate_min(weapon)
    weapon.max_damage = DamageGenerator.generate_max(weapon)

    weapon.stats = StatsGenerator.generate(weapon, StatsFormatter.format_array(params))
    weapon.name = NameGenerator.generate(weapon, params['suffix'] == 'true', true)
    return weapon
  end

  def self.save_sql(weapons, filename, params)
    file = File.open(filename, 'w')

    weapons.each do |weapon|
      file.puts weapon.generate_query
    end

    file.close
    WeaponTokenGenerator.generate(params, filename) if params['crate'] == 'yes'
  end
end