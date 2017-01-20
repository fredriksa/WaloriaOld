class ItemLevel
  def self.calculate(params)
    level = params["level"].to_i
    modifier = params["ilevel"].to_i

    base_ilvl = level + 5 + modifier

    # Add 10% variety to itemlevel if not static
    if params['staticitemlevel'] == 'No' 
      return rand((base_ilvl*0.9)..((base_ilvl*1.1))).ceil
    else
      return base_ilvl
    end
  end
end