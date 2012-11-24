module Shrinker
  class Extractor < Struct.new(:token, :config)
    class UrlNotFound < ArgumentError; end;

    def self.unshrink(token, config = nil)
      self.new(token, config).unshrink
    end

    def unshrink
      stored_content = backend.fetch(token)
      raise UrlNotFound.new("Cannot find the url with token: #{token}") if stored_content == {}

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