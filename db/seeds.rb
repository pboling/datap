# frozen_string_literal: true

require 'colorized_string'

seed_size = ENV['SEED_SIZE'] ? ENV['SEED_SIZE'].to_i : 1_000_000

data_list = DataList.seeder(
  size: seed_size,
  first_date: Time.now,
  min_sequential_days: 30
)

red_dot = ColorizedString['.'].red.on_blue
puts "Importing #{seed_size} PageViews, each '#{red_dot}' represents 10,000\n"
data_list.each.each_slice(10_000) do |list|
  PageView.import(
    DataList::COLUMNS,
    list,
    validate: false
  )
  print red_dot
end
puts "\nImported #{seed_size} PageViews"
