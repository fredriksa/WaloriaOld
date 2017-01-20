class QualityBudget
  def self.uncommon(itemlevel)
    calculate_budget(itemlevel, QualityModifiers.get_budget(:uncommon), 1)
  end

  def self.rare(itemlevel)
    calculate_budget(itemlevel, QualityModifiers.get_budget(:rare), 1.5)
  end

  def self.epic(itemlevel)
    calculate_budget(itemlevel, QualityModifiers.get_budget(:epic), 2)
  end

  private
  def self.calculate_budget(itemlevel, modifier, penalty)
    (modifier * itemlevel - penalty).ceil
  end
end