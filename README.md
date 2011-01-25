TimedConfig
===========

Load a YAML config every X minutes

Requirements
------------

<pre>
gem install timed_config
</pre>

Install
-------

### Rails 2

#### config/environment.rb

<pre>
config.gem 'timed_config'
</pre>

### Rails 3

#### Gemfile

<pre>
gem 'timed_config'
</pre>

### Other

<pre>
require 'timed_config'
</pre>

Defaults
--------

If you are using Rails, <code>TimedConfig</code> will try to locate the YAML config at <code>config/timed_config.yml</code>.

By default, the refresh period is set to 1 minute.

Changing defaults
-----------------

<pre>
TimedConfig.period = 120 # change period to two minutes
TimedConfig.path = "path/to/yaml.yml"
</pre>

The config will reload any time a setting changes.

Accessing the config
--------------------

<pre>
TimedConfig.config
</pre>