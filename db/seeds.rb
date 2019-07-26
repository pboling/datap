# frozen_string_literal: true

require 'colorized_string'
require 'benchmark'

BENCHMARK_MARKER = ColorizedString['------ BENCHMARK'].green.on_black

def bench(task_name)
  puts "\n#{BENCHMARK_MARKER}-START: #{ColorizedString[task_name].green.on_black}\n"
  seconds = Benchmark.realtime do
    yield if block_given?
  end
  puts "\n#{BENCHMARK_MARKER}-FINISH: #{ColorizedString[task_name].green.on_black} #{ColorizedString[format('%f', seconds)].yellow.on_black} seconds\n"
end

seed_size = ENV['SEED_SIZE'] ? ENV['SEED_SIZE'].to_i : 1_000_000
sequential_days = ENV['SEQ_DAYS'] ? ENV['SEQ_DAYS'].to_i : 30
slice_size = ENV['SEED_SLICE_SIZE'] ? ENV['SEED_SLICE_SIZE'].to_i : 10_000
data_list = nil

bench('Building Entropy') do
  data_list = DataList.seeder(
    size: seed_size,
    sequential_days: sequential_days,
    print_every_x: slice_size
  )
end

bench("Importing #{seed_size} PageViews") do
  puts "Each '#{DataList::RED_DOT}' represents 10,000 page views\n"
  puts '.' * (1_000_000 / slice_size) + ' 100%'
  data_list.each.each_slice(slice_size) do |list|
    PageView.import(
      DataList::COLUMNS,
      list,
      validate: false
    )
    print DataList::RED_DOT
  end
  print "\n"
end
