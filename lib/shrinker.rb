require "shrinker/version"

module Shrinker
  autoload :Config, 'shrinker/config'

  module Backend
    autoload :Abstract, 'shrinker/backend/abstract'
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
