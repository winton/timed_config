require 'yaml'

module TimedConfig
  
  class <<self
    attr_accessor :config
    
    def path
      @path || (defined?(Rails) ? "#{Rails.root}/config/timed_config.yml" : nil)
    end
    
    def path=(p)
      thread.stop rescue nil
      @path = p
      thread.run
    end
    
    def period
      @period || 60
    end
    
    def period=(seconds)
      thread.stop rescue nil
      @period = seconds
      thread.run
    end
    
    def thread
      @thread ||= Thread.new do
        while true
          if TimedConfig.path && File.exists?(TimedConfig.path)
            TimedConfig.config = YAML::load(File.open(TimedConfig.path))
          end
          sleep TimedConfig.period
        end
      end
    end
    
    TimedConfig.thread
  end
end