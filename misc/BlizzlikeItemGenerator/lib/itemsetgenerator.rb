class Itemsetgenerator
  def self.generate(params, user_id)
    files = []
    temp_params = params.dup

    slots = ["Head", ["Neck", "Neck"], "Shoulder", ["Back", "Cloth"], "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands",
            ["Finger", "Finger"], ["Trinket", "Trinket"]] #Slots that will be generated
    #We have to manually enter the subclass for neck, back, finger and trinket
    entry_modifier = 0
    temp_params['token_loot_distance_start'] = 0

    slots.each do |slot|
      # We need to handle wearables that are not of type Cloth, Leather etc..
      if slot.is_a? Array 
        temp_params['slot'] = slot[0]
        temp_params['subclass'] = slot[1]
      else
        temp_params['slot'] = slot
        temp_params['subclass'] = params['subclass']
      end

      files << ItemGenerator.generate(temp_params, user_id, entry_modifier)
      entry_modifier += params['amount'].to_i

      # If we have generated items for one slot we have to make room for possible crate item
      entry_modifier += 1

      # We have to keep track on what the next token ID should be
      temp_params['next_item_token_id'] = params['id'].to_i + entry_modifier + params['amount'].to_i
      # We have to keep track on how far away from 'start position' we are 
      temp_params['token_loot_distance_start'] += params['amount'].to_i + 1
    end

    filename = "./sql/merged_itemset_#{user_id}.sql"

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