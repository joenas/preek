require 'coveralls'
Coveralls.wear!

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'stringio'
require File.expand_path('../../lib/preek', __FILE__)
require 'rspec/given'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.fail_fast = true
end
