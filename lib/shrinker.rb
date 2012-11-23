require "shrinker/version"
require "json"

module Shrinker
  autoload :Config,     'shrinker/config'
  autoload :Serializer, 'shrinker/serializer'
  autoload :Extractor,  'shrinker/extractor'
  autoload :EasyUrl,    'shrinker/easy_url'
  autoload :Token,      'shrinker/token'

  module Backend
    autoload :Abstract, 'shrinker/backend/abstract'
    autoload :Redis,    'shrinker/backend/redis'
  end

  module Parser
    autoload :Abstract, 'shrinker/parser/abstract'
    autoload :Url,      'shrinker/parser/url'
    autoload :Text,     'shrinker/parser/text'
  end

  class << self
    def configure(&block)
      if block_given?
        configuration.instance_eval(&block)
      end
      configuration
    end
    alias_method :config, :configure

    def unshrink(token)
      extractor.unshrink(token)
    end

    protected

    def configuration
      @configuration ||= ::Shrinker::Config.new
    end

    def extractor
      @extractor     ||= ::Shrinker::Extractor.new(config)
    end

    def backend
      config.backend_instance
    end
  end
end
