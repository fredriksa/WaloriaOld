class String
  def capitalize_first
    self[0].capitalize + self[1..self.size]
  end
end