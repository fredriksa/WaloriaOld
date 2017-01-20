class ErrorChecker
  attr_accessor :error

  def initialize(params, user)
      if params['amount'].to_i > 4 && user.rank.id != 1
      @error = "You are not allowed to generate more than 4 variations at a time!"
    end

    #If stats are empty
    if StatsFormatter.empty_stats? params
      @error = "You must select at least one stat!"
    end

    #If not more than 10 stats are selected
    unless StatsFormatter.within_size?(params, 11)
      @error = "You must select less than 10 stats (including random stats)"
    end

    #Checks if user has uses left
    if user.rank.id == 3 && user.uses <= 20
      user.uses += 1
      user.save!
    elsif user.rank.id == 3
      @error = "You've used up your 20 generations!"
    end
  end

  def error?
    !error.nil?
  end
end