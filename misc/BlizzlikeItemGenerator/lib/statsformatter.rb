class StatsFormatter
  def self.format_array(params)
    stats_base = base_stats(params)
    stats_random = random_stats(params)
    stats = combine_stats(stats_base, stats_random)
    p stats 
    stats
  end

  def self.within_size?(params, size)
    format_array(params).length < size
  end

  def self.empty_stats?(params)
    stats = format_base_stat_array(params)
    stat_symbol_array(stats).empty?
  end

  private
  # Returns all the base stats that must exist on a item in array form with keys
  def self.base_stats(params)
    stats = format_base_stat_array(params)
    stat_symbol_array(stats)
  end

  # Generates and returns the random stats which might exist on the item
  def self.random_stats(params)
    random_stats = format_random_stat_array(params)
    random_stats_array = stat_symbol_array(random_stats)
    select_random_stats(random_stats_array, params)
  end

  # Returns combined unique stats
  def self.combine_stats(stats, stats2)
    (stats + stats2).uniq
  end


  def self.select_random_stats(stats, params)
    random_stats = []

    # Select our target amount of random stats, somewhere between min and max provided amount
    target_amount = (params['minrstats']..params['maxrstats']).to_a.sample.to_i

    #We use X as a safety measurement if user input would be invalid, to prevent the system from locking
    x = 0
    while random_stats.size != target_amount
      stats.each do |stat|
        break if random_stats.size == target_amount 

        unless random_stats.include? stat
          if rand(0..1) == 1
            random_stats << stat
          end
        end 
      end

      x += 1
      break if x > 50
    end

    random_stats
  end

  # Returns for instance [:strength, :agility, :stamina]
  def self.stat_symbol_array(stats)
    # Stats which actually contained a value
    real_stats = []

    stats.map do |stat|
      next if stat.nil? || stat == 'none' 
      real_stats << stat.to_sym
    end

    real_stats.flatten
  end

  def self.format_random_stat_array(params)
    [params['rstat1'], params['rstat2'], params['rstat3'], params['rstat4'], params['rstat5'], params['rstat6'], params['rstat7'], params['rstat8'], params['rstat9'], params['rstat10']]
  end

  def self.format_base_stat_array (params)
    [params['stat1'], params['stat2'], params['stat3'], params['stat4'], params['stat5'], params['stat6'], params['stat7'], params['stat8'], params['stat9'], params['stat10']]
  end
end