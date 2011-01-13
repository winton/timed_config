# -*- encoding: utf-8 -*-
root = File.expand_path('../', __FILE__)
lib = "#{root}/lib"
$:.unshift lib unless $:.include?(lib)
 
require 'timed_config/gems'
TimedConfig::Gems.gemset ||= ENV['GEMSET'] || :default

Gem::Specification.new do |s|
  TimedConfig::Gems.gemspec.hash.each do |key, value|
    if key == 'name' && TimedConfig::Gems.gemset != :default
      s.name = "#{value}-#{TimedConfig::Gems.gemset}"
    elsif key == 'summary' && TimedConfig::Gems.gemset == :solo
      s.summary = value + " (no dependencies)"
    elsif !%w(dependencies development_dependencies).include?(key)
      s.send "#{key}=", value
    end
  end

  TimedConfig::Gems.dependencies.each do |g|
    s.add_dependency g.to_s, TimedConfig::Gems.versions[g]
  end
  
  TimedConfig::Gems.development_dependencies.each do |g|
    s.add_development_dependency g.to_s, TimedConfig::Gems.versions[g]
  end

  s.executables = `cd #{root} && git ls-files -- {bin}/*`.split("\n").collect { |f| File.basename(f) }
  s.files = `cd #{root} && git ls-files`.split("\n")
  s.require_paths = %w(lib)
  s.test_files = `cd #{root} && git ls-files -- {features,test,spec}/*`.split("\n")
end