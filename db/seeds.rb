# frozen_string_literal: true

seed_size = ENV['SEED_SIZE'] ? ENV['SEED_SIZE'].to_i : 1_000_000

data_list = DataList.seeder(
  size: seed_size,
  first_date: Time.now,
  min_sequential_days: 30
)

data_list.each.each_slice(100) do |list|
  PageView.import(
    DataList::COLUMNS,
    list,
    validate: false
  )
end
