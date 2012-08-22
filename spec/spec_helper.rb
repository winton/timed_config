require 'pp'

$root = File.expand_path('../../', __FILE__)
require "#{$root}/lib/timed_config/gems"

TimedConfig::Gems.activate :rspec

require "#{$root}/lib/timed_config"

Spec::Runner.configure do |config|
end

def write_to_fixture(data, config="#{$root}/spec/fixtures/config.yml")
  File.open(config, 'w') {|f| f.write(data) }
end