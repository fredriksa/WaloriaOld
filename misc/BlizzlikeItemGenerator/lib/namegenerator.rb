class NameGenerator
  # Name formats
  # prefix slot of the suffix

  def self.generate(item, suffix = false, weapon = false)
    sorted_stats = sort_stats(item.stats)
    sorted_stats = clean_stats(sorted_stats)

    # Suffix gets generated from primary stat and prefix from secondary stat
    primary_stat = sorted_stats.last

    # Generate all the sections of the name
    if weapon

      # Check if we have to add subclass suffix (oneh, twoh..)
      if [:Axe, :Mace, :Sword].include? item.subclass
        subclass = Subclass.first(name: item.subclass)
        prefix = get_name_list('prefix_'+subclass.name+subclass.name_suffix).sample
        itemslot = get_name_list(subclass.name+subclass.name_suffix).sample
      else
        prefix = get_name_list('prefix_'+item.subclass.to_s.delete(' ')).sample
        itemslot = get_name_list(item.subclass.to_s.delete(' ')).sample
      end

      # If armor/item
    else
      prefix = get_name_list("subclass_" + item.subclass.to_s).sample
      itemslot = get_name_list("slot_"+item.slot.to_s+"_"+item.subclass.to_s).sample
    end

    # If we want to generate a suffix
    if suffix 
      suffix = get_name_list("stat_" + primary_stat).sample
      return build_name_with_suffix(prefix, itemslot, suffix)
    else
      return build_name(prefix, itemslot)
    end

  end

  private
  # Returns the sorted stats in 2d array. The first index being the stat with the lowest value.
  # => [[:agility, 5], [:strength, 5], [:stamina, 5]]
  def self.sort_stats(stats)
    stats.sort_by {|stat, value| value}
  end

  # Flattens the array, cleans it from anything but symbols and converts the symbols to strings.
  # [[:agility, 5], [:strength, 10], [:stamina, 5]]
  # => ["agility", "strength", "stamina"]
  def self.clean_stats(stats)
    stats = stats.dup
    stats.flatten!
    stats.keep_if {|stat| stat.is_a? Symbol}
    stats.map! {|stat| stat.to_s}
  end

  # Gets the different names the stat/slot could have.
  # get_name_list("strength", true)
  # => ["eagle", "bear", "kingslayer"]
  # get_name_list("strength", false)
  # => ["of strength", "of manlyness"]
  def self.get_name_list(name)
    names = File.read("./names/#{name.downcase}.txt")

    names = names.split("\n")
  end

  def self.build_name(prefix, itemslot)
    #prefix + " " + itemslot
    prefix + " " + itemslot
  end

  def self.build_name_with_suffix(prefix, itemslot, suffix)
    build_name(prefix, itemslot) + " " + suffix
  end
end