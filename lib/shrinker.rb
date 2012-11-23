require "shrinker/version"
require "json"

module Shrinker
  autoload :Config,     'shrinker/config'
  autoload :Serializer, 'shrinker/serializer'

  module Backend
    autoload :Abstract, 'shrinker/backend/abstract'
    autoload :Redis,    'shrinker/backend/redis'
  end

  class << self
    def configure(&block)
      if block_given?
        configuration.instance_eval(&block)
      end
      configuration
    end
    alias_method :config, :configure

    protected

    def configuration
      @configuration ||= ::Shrinker::Config.new
    end

    def backend
      @backend ||= begin
        class_name = (self.config.backend || 'Abstract').to_s
        Backend.const_get(class_name).new(self.config.backend_options || {})
      end
    end
  end
end
