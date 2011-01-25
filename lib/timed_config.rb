require 'yaml'

module TimedConfig
  class <<self
    
    def config
      reload
    end
    
    def path
      @path || (defined?(Rails) ? "#{Rails.root}/config/timed_config.yml" : nil)
    end
    
    def path=(p)
      @path = p
      reload true
      p
    end
    
    def period
      @period || 60
    end
    
    def period=(p)
      @period = p
      reload true
      p
    end
    
    def reload(force=false)
      if force || !@last_load || Time.now >= (@last_load + period)
        if TimedConfig.path && File.exists?(TimedConfig.path)
          @config = YAML::load(File.open(TimedConfig.path))
        else
          @config = nil
        end
        @last_load = Time.now
      end
      @config
    end
    
    TimedConfig.reload
  end
end