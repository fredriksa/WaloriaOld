class WeaponTokenGenerator
  

  def self.generate(params, filename)
    weapontoken = WeaponToken.new

    # If we have a decided ID from the itemset generator
    if params['next_weapon_token_id'].nil?
      weapontoken.entry = params['id'].to_i + params['amount'].to_i
    else
      weapontoken.entry = params['next_weapon_token_id'].to_i
    end

    weapontoken.ilevel = params['tokenilevel'].to_i
    weapontoken.subclass = params['subclass'].to_sym
    weapontoken.quality = params['quality'].to_sym
    weapontoken.slot = params['slot'].to_sym
    weapontoken.bonding = params['bonding'].to_sym
    weapontoken.start_entry = params['id']
    weapontoken.end_entry = weapontoken.entry - 1

    query = weapontoken.generate_query(params)
    self.save_query(query, filename)
    query = weapontoken.loot_query(params)
    self.save_query(query, filename)
  end

  private
  def self.save_query(query, filename)
    file = File.open(filename, 'a')
    file.puts query
    file.close
  end

end