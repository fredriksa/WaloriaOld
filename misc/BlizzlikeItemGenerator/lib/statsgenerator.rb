
class StatsGenerator

  def self.generate(item, *stats)

    quality_budget = Quality.first(name: item.quality).budget(item.itemlevel)
    slotbudget = Slot.first(name: item.slot).budget(quality_budget)

    stat_rates = stat_rates(stats)
    total_points = itemization_points(slotbudget, stat_rates[:leftover])
    points = split_points(total_points, stat_rates)

    # Converts back from imteization_points to actual stat points
    stat_points = stat_points(points)

    stats = generate_stats(stat_points)
    delete_empty_stats(stats)
  end

  def self.set_unavailable_rate(new_rate)
    @@unavailable_rate = new_rate
  end

  private
  # Splits rates from 0 - 1 (1 => 100%)
  def self.stat_rates(*stats)
    stats = stats.each_slice(1).to_a.flatten
    # Hash containing the rates & leftover: rate
    stat_rates = {}

    # Lowest rate a stat can have
    lowest_rate = @@unavailable_rate / stats.length
    # Available rate for giveaways
    available_rate = 1 - @@unavailable_rate

    # Set the base rate of each stat
    stats.each do |stat|
      if stat_rates[stat].nil?
        stat_rates[stat] = lowest_rate
      end
    end

    # Calculate rate for each stat 'scaling'
    #while available_rate > 0.01 do
    #  stats.each do |stat|
    #    # Set the base rate (the lowest rate a stat can have)
 
        # Calculate the additional rate. The first stat to be calculated
        # Got a bigger chance of a higher additional rate
    #    additional_rate = rand(0..available_rate.round(2))
    #    available_rate -= additional_rate
    #    stat_rates[stat] += additional_rate

        # Round the stat rate to two digits
    #    stat_rates[stat] = stat_rates[stat].round(2)
    #  end
    #end

    # Divider for the amount of stat points we give out at max per time (the lower the more distributed random stats)
    available_rate_divider = 5
    # Calculate rate for each stat 'true random'
    while available_rate > 0.01 do
      stat = stats.sample

      additional_rate = rand(0..(available_rate.round(2)/available_rate_divider))
      available_rate -= additional_rate
      stat_rates[stat] += additional_rate

      # Round the stat rate to two digits
      stat_rates[stat] = stat_rates[stat].round(2)
    end

    # We save the points which haven't been added to a stat
    # To later increase the full itemization points with
    stat_rates[:leftover] = available_rate

    return stat_rates
  end

  # Calculates theitemization points and take in account the leftovers
  # From dividing stats
  def self.itemization_points(budget, leftover_rate)
    points = (budget**1.5).round(2) 
    (points + points * leftover_rate).round(2)
  end

  # Splits points depending on rates
  def self.split_points(points, rates)
    point_split = {}

    rates.each do |stat, rate|
      next if stat == :leftover 

      point_split[stat] = (points * rate).round(0)
    end

    return point_split
  end

  # Converts itemization points to stat points (one stat point = one of that spot)
  def self.stat_points(points)
    stat_points = {}

    points.each do |stat, points|
      stat_points[stat] = points**(1/1.5)
    end

    stat_points
  end

  # Generates the stats from the points given
  def self.generate_stats(points)
    stats = {}

    points.each do |stat, points| 
      cost = Stat.first(name: stat).cost
      if cost
        stats[stat] = ((1 + 1 - cost) * points).round()
      end
    end

    stats
  end

  # Clears the stat hash of empty stats
  def self.delete_empty_stats(stats)
    stats = stats.dup

    stats.each do |stat, value|
      stats.delete(stat) if value <= 0
    end

    stats
  end
end