# frozen_string_literal: true

require 'colorized_string'
require 'benchmark'

BENCHMARK_MARKER = ColorizedString['------ BENCHMARK'].green.on_black

def bench(task_name, &block)
  puts "\n#{BENCHMARK_MARKER}-START: #{ColorizedString[task_name].green.on_black}\n"
  seconds = Benchmark.realtime do
    yield if block_given?
  end
  puts "\n#{BENCHMARK_MARKER}-FINISH: #{ColorizedString[task_name].green.on_black} #{ColorizedString[sprintf("%f", seconds)].yellow.on_black} seconds\n"
end

seed_size = ENV['SEED_SIZE'] ? ENV['SEED_SIZE'].to_i : 1_000_000
sequential_days = ENV['SEQ_DAYS'] ? ENV['SEQ_DAYS'].to_i : 30
slice_size = ENV['SEED_SLICE_SIZE'] ? ENV['SEED_SLICE_SIZE'].to_i : 10_000
data_list = nil

bench('Building Entropy') do
  data_list = DataList.seeder(
    size: seed_size,
    first_date: Time.now,
    sequential_days: sequential_days
  )
end

red_dot = ColorizedString['.'].red.on_yellow

bench("Importing #{seed_size} PageViews") do
  puts "Each '#{red_dot}' represents 10,000\n"
  data_list.each.each_slice(slice_size) do |list|
    PageView.import(
        DataList::COLUMNS,
        list,
        validate: false
    )
    print red_dot
  end
  print "\n"
end
