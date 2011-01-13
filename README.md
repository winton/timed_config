TimedConfig
===========

Starts a thread that loads a YAML config every X minutes

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
config.gem 'acts_as_archive'
</pre>

### Rails 3

#### Gemfile

<pre>
gem 'acts_as_archive'
</pre>

### Other

<pre>
require 'acts_as_archive'
</pre>

Starts by default
-----------------

<code>TimedConfig</code> will start automatically when you require it.

If you are using Rails, it will try to find the config in <code>config/timed_config.yml</code>.

By default, the refresh period is set to 1 minute.

Accessing the config
--------------------

<pre>
TimedConfig.config
</pre>

Changing defaults
-----------------

<pre>
TimedConfig.period = 120 # change period to two minutes
TimedConfig.path = "path/to/yaml.yml"
</pre>

The config will reload any time one of these settings change.