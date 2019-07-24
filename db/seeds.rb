# frozen_string_literal: true

require 'colorized_string'

seed_size = ENV['SEED_SIZE'] ? ENV['SEED_SIZE'].to_i : 1_000_000
sequential_days = ENV['SEQ_DAYS'] ? ENV['SEQ_DAYS'].to_i : 30
slice_size = ENV['SEED_SLICE_SIZE'] ? ENV['SEED_SLICE_SIZE'].to_i : 10_000

data_list = DataList.seeder(
  size: seed_size,
  first_date: Time.now,
  sequential_days: sequential_days
)

red_dot = ColorizedString['.'].red.on_blue
puts "Importing #{seed_size} PageViews, each '#{red_dot}' represents 10,000\n"
data_list.each.each_slice(slice_size) do |list|
  PageView.import(
    DataList::COLUMNS,
    list,
    validate: false
  )
  print red_dot
end
puts "\nImported #{seed_size} PageViews"
