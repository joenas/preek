require 'coveralls'
Coveralls.wear!

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'stringio'
require File.expand_path('../../lib/preek', __FILE__)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.fail_fast = true
end
