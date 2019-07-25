require 'vcr'
require 'webmock/rspec'

debug = ENV['DEBUG'] == 'true'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.debug_logger = $stderr if debug
end
