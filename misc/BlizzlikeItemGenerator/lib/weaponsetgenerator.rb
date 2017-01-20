class Weaponsetgenerator
  def self.generate(params, user_id)
    files = []
    temp_params = params.dup

    slots = [ #Slots with subclasses that will be generated
      ["One-Hand", ["Axe", "Mace", "Sword", "Fist Weapon", "Dagger"]],
      ["Two-Hand", ["Axe", "Mace", "Sword", "Polearm", "Staff"]],
      ["Bow", ["Bow"]],
      ["Gun", ["Gun"]],
      ["Wand", ["Wand"]]
    ]

    entry_modifier = 0
    temp_params['token_loot_distance_start'] = 0

    slots.each do |slot|
      # We need to handle wearables that are not of type Cloth, Leather etc..
      temp_params['slot'] = slot.first 

      slot[1].each do |subclass| 
        temp_params['subclass'] = subclass
        files << WeaponGenerator.generate(temp_params, user_id, entry_modifier)
        entry_modifier += params['amount'].to_i
        # Ok so we are generating for every combo, but the entries are all wrong.
        # If we have generated items for one slot we have to make room for possible crate item
        entry_modifier += 1

        # We have to keep track on what the next token ID should be
        temp_params['next_weapon_token_id'] = params['id'].to_i + entry_modifier + params['amount'].to_i
        puts "########################"
        puts "########################"
        puts "Next token entry: ", temp_params['next_weapon_token_id']
        puts "########################"
        puts "########################"
        # We have to keep track on how far away from 'start position' we are 
        temp_params['token_loot_distance_start'] += params['amount'].to_i + 1
      end
    end

    filename = "./sql/merged_weaponset_#{user_id}.sql"

    files.each do |file|
      merge_sql(file, filename)
    end

    return filename
  end

  def self.merge_sql(file, target_file)
    file = File.open(file, 'r')

    if File.exists? target_file
      target_file = File.open(target_file, 'a')
    else
      target_file = File.open(target_file, 'w')
    end
    
    file_lines = file.readlines

    file_lines.each do |line|
      target_file.puts line
    end

    file.close
    target_file.close
  end
end