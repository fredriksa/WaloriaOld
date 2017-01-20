class Generator
  #generates item from selected params
  def self.generate(params, user_id)
    entry_modifier = 0
    items = []
    items_to_create = params['amount'].to_i
    items_to_create.times do
      items << generate_item(params, entry_modifier)
      entry_modifier += 1
    end
    
    filename = "./sql/merged_items_#{user_id}.sql"
    self.save_sql(items, filename)
    return filename
  end

  private
  def self.generate_item(params, entry_modifier)
    StatsGenerator.set_unavailable_rate params['unavailable'].to_f

    item = Item.new
    item.entry = params['id'].to_i + entry_modifier
    item.level = params['level'].to_i
    item.bonding = 1
    item.class = :armor
    item.quality = params['quality'].to_sym
    item.slot = params['slot'].to_sym
    item.subclass = params['subclass'].to_sym
    item.display_id = params['display'].to_i
    item.itemlevel = ItemLevel.calculate(item.level)
    item.armor = ArmorGenerator.generate(item)
    item.sellprice = PriceGenerator.sell_price(item)
    item.buyprice = PriceGenerator.buy_price(item)
    item.durability = DurabilityGenerator.generate(item)

    item.stats = StatsGenerator.generate(item, StatsFormatter.format_array(params))
    item.name = NameGenerator.generate(item, params['suffix'] == 'true')
    return item
  end

  def self.save_sql(items, filename)
    file = File.open(filename, 'w')

    items.each do |item|
      file.puts item.generate_query
    end

    file.close
  end
end