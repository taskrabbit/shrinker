module Shrinker
  class Config

    # provides a getter and a setter with the same method
    # config_setting :dog
    #   --> dog 'Husky' :=> 'Husky' (setter)
    #   --> dog :=> 'Husky' (getter)

    def self.settings
      @settings ||= []
    end

    def self.config_setting(name)
      settings << name

      class_eval <<-EV, __FILE__, __LINE__ + 1
        attr_reader :#{name}

        def #{name}(value = nil)
          return @#{name} if value.nil?
          @#{name} = value
          value
        end
      EV
    end

    # the backend to be used to store the real url
    config_setting :backend

    # the options to pass to the backend
    config_setting :backend_options

    # domain to be shrinked can be a regex
    config_setting :expanded_pattern

    # regex for the url path to be excluded
    config_setting :exclude_path

    # regex to mactch/exclude the pattern when matching around patterns
    config_setting :around_pattern

    # domain to be used when shrinking the urls
    config_setting :shrinked_pattern

    # setting boolean to replace links only in anchor tags href inside html
    config_setting :anchors_only_in_html

    # how long should url tokens be, default 6
    config_setting :token_length_target

    # how should it generate new tokens: longer (default), random
    config_setting :token_length_strategy

    def ==(config)
      self.class.settings.each { |setting| return false unless send(setting) == config.send(setting) }

      true
    end

    def reset!
      self.instance_variables.each do |var|
        self.instance_variable_set(var, nil)
      end
    end

    def merge(config)
      new_config = Config.new
      new_config.merge!(config)

      new_config
    end

    def merge!(config)
      case config
      when self.class
        self.class.settings.each { |setting| send(setting, config.send(setting)) }
      when Hash
        config.each_pair do |setting, value|
          send(setting, value)
        end
      end
    end

    def backend_instance
      @backend_instance ||= begin
        class_name = (backend || 'Abstract').to_s
        ::Shrinker::Backend.const_get(class_name).new(backend_options || {})
      end
    end
  end
end
