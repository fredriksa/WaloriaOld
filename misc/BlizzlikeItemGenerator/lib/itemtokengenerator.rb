class ItemTokenGenerator
  

  def self.generate(params, filename)
    itemtoken = ItemToken.new

    # If we have a decided ID from the itemset generator
    if params['next_item_token_id'].nil?
      itemtoken.entry = params['id'].to_i + params['amount'].to_i
    else
      itemtoken.entry = params['next_item_token_id'].to_i
    end
    
    itemtoken.ilevel = params['tokenilevel'].to_i
    itemtoken.subclass = params['subclass'].to_sym
    itemtoken.quality = params['quality'].to_sym
    itemtoken.slot = params['slot'].to_sym
    itemtoken.bonding = params['bonding'].to_sym
    itemtoken.start_entry = params['id']
    itemtoken.end_entry = itemtoken.entry - 1

    query = itemtoken.generate_query(params)
    self.save_query(query, filename)
    query = itemtoken.loot_query(params)
    self.save_query(query, filename)
  end

  private
  def self.save_query(query, filename)
    file = File.open(filename, 'a')
    file.puts query
    file.close
  end

end