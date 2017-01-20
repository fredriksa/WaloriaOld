class Displayselector
  @@level_variance = 2

  def self.select(params, armor = true) 
    # Checking for nil in setgenreator(s)
    if params['display'] == "0" || params['display'] == nil
      inventorytype = nil
      class_id = nil
      subclass_id = nil

      if armor 
        subclass = Subclass.first(name: params['subclass'])
        subclass_id = subclass.db_id
        inventorytype = Slot.first(name: params['slot']).db_id
        class_id = 4
      else #if weapon
        slot = Slot.first(name: params['slot'])
        
        subclass = nil
        if slot.name == "Two-Hand" 
          subclass = Subclass.first(name: params['subclass'], twohanded: true)
        else
          subclass = Subclass.first(name: params['subclass'])
        end

        subclass_id = subclass.db_id

        inventorytype = slot.db_id
        if subclass.onehanded 
          inventorytype = [13, 21, 22]
        elsif subclass.ranged
          inventorytype = [15, 26, 25]
        end
        
        class_id = 2
      end

      if (params['display'] == "0" || params['display'] == nil) && params['displaylevel'] != 0
        return self.get_display(class_id, subclass_id, inventorytype, params['displaylevel'].to_i)
      else
        return self.get_display(class_id, subclass_id, inventorytype, params['level'].to_i)
      end
    end

    return params['display'].to_i
  end

  def self.get_display(class_id, subclass_id, inventorytype, level)
    level_range = self.base_level_range(level)

    candidates = get_candidates(level_range, class_id, subclass_id, inventorytype)
    return candidates.sample.displayid
  end

  def self.get_candidates(level_range, class_id, subclass_id, inventorytype)
    level_range = level_range.dup
    min_range = level_range.min
    max_range = level_range.max

    candidates = []
    while candidates.empty?
      if min_range < 200 and max_range > 200 
        break
      end

      candidates = Display.all(class_id: class_id, subclass_id: subclass_id, requiredlevel: level_range, inventorytype: inventorytype)
      min_range -= 1
      max_range += 1
      level_range = min_range..max_range
    end

    return candidates
  end

  def self.base_level_range(level)
    if level != 1 && level - @@level_variance <= 1
      min_level = 2
    else
      min_level = level - @@level_variance
    end

    max_level = level + @@level_variance

    return min_level..max_level
  end
end