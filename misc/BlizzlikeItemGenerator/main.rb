require_relative "./lib/item.rb"
require_relative "./lib/qualitybudget.rb"
require_relative "./lib/slotbudget.rb"
require_relative "./lib/statsgenerator.rb"
require_relative "./lib/namegenerator.rb"
require_relative "./lib/string.rb"
require_relative "./lib/armorgenerator.rb"
require_relative "./lib/slotmodifiers.rb"
require_relative "./lib/armormodifiers.rb"

def save_sql(item, filename)
  File.open(filename, 'w') { |file| file.write(item.generate_query) }
end

def random_entries(arr)
  start_arr = rand(0..arr.size-1)
  end_arr = rand(start_arr..arr.size-1)

  arr[start_arr..end_arr]
end

def random_entry(arr)
  random_entries(arr).sample
end

stats = [:strength, :agility, :intellect, :spirit, :stamina, :attackpower, :spelldamage, :healing, :manapersec, :magicpenetration]
slots = [:chest, :feet, :hands, :head, :legs, :shoulder, :waist, :wrist]
qualities = [:uncommon, :rare, :epic]
subclasses = [:cloth, :leather, :mail, :plate]

random = false

# The amount we don't randomly give away, the higher the more even the stats will become. (0.x - 0.9x)
StatsGenerator.set_unavailable_rate 0.50

print "Enter level requirement: " # level
level = gets.chomp.to_i
print "Enter slot: " # chest, feet, hands, head, legs, shoulder, waist, wrist
slot = gets.chomp.to_sym
print "Enter subclass: " # cloth, leather, mail, plate
subclass = gets.chomp.to_sym
print "Enter display id: "
display_id = gets.chomp.to_i
print "Enter amount of items: "
x = gets.chomp.to_i
print "Enter starting ID: "
start_db_entry = gets.chomp.to_i
print "Random stats (y/n): "
random_stats = gets.chomp
print "Enter quality: "
quality = gets.chomp.to_sym

if random_stats == 'n'
  stats = stats.clear
  puts "Enter stats, q to quit: "
  loop do 
    input = gets.chomp
    break if input == 'q'

    stats << input.to_sym
  end
end

x.times do 
  item = Item.new

  item.level = level
  item.bonding = 1 # no bonds, (binds on pickup etc.)
  item.durability = 100 # Durability of item
  item.class = :armor #weapon, armor
  item.quality = quality
  item.slot = slot 
  item.subclass = subclass # cloth, leather, mail, Let's add names to the other sublcasses for head

  item.display_id = display_id
  item.sellprice = 1 # Coppar

  item.itemlevel = ItemLevel.calculate(level)
  item.armor = ArmorGenerator.generate(item)

  item.entry = start_db_entry

  item.stats = StatsGenerator.generate(item, stats)

  item.name = NameGenerator.generate(item)
  sleep 0.1
  
  save_sql(item, "sql/item_#{item.entry}.sql")
  start_db_entry += 1
end

puts "Merging SQL queries into merged_items.sql"

# Changes dir while inside this block
Dir.chdir('sql') {
  system "copy *.sql merged_items.sql"
}
