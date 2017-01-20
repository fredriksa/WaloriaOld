class SlotBudget
  def self.calculate(slot, quality_budget)
    (Slot.first(name: slot).base_mod * quality_budget).ceil
  end
end