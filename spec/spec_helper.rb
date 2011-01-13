require 'pp'

$root = File.expand_path('../../', __FILE__)
require "#{$root}/lib/timed_config/gems"

TimedConfig::Gems.activate :rspec

require "#{$root}/lib/timed_config"

Spec::Runner.configure do |config|
end