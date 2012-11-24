module Shrinker
  class Extractor < Struct.new(:token, :config)
    UrlNotFound = ArgumentError.new

    def self.unshrink(token, config = nil)
      self.new(token, config).unshrink
    end

    def unshrink
      stored_content = backend.fetch(token)
      if stored_content == {}
        raise UrlNotFound
      end
      EasyUrl.new(stored_content['url'], stored_content['attributes'] || {})
    end

    protected

    def backend
      config.backend_instance
    end

    def config
      super || Shrinker.config
    end
  end
end