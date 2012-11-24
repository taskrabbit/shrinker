module Shrinker
  class Config

    # provides a getter and a setter with the same method
    # config_setting :dog
    #   --> dog 'Husky' :=> 'Husky' (setter)
    #   --> dog :=> 'Husky' (getter)
    def self.config_setting(name)
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
    config_setting :expanded_domain

    # regex for links to be excluded
    config_setting :exclude

    # domain to be used when shrinking the urls
    config_setting :shrinked_domain

    def reset!
      self.instance_variables.each do |var|
        self.instance_variable_set(var, nil)
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
