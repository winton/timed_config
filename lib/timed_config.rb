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
      @paths = [p]
      p
    end

    def paths
      return @paths unless @paths.nil? || @paths.empty?
      path.nil? ? [] : [path]
    end

    def paths=(p)
      @paths = paths
      @paths.push(p)
      reload true
      @paths
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
        p_array = paths

        unless p_array.empty?
          @config = {}
          p_array.each do |p|
            @config.merge!(YAML::load(File.open(p))) if File.exists? p
          end
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