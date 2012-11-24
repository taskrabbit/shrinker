module Shrinker
  module Backend
    class Redis < Abstract
      require 'redis'

      def initialize(options = {})
        super
        @client_options = options[:client] || {}
        @namespace      = options[:namespace] || '_shrinker'
      end

      def store(raw_url, token, attributes = {})
        content   = Shrinker::Serializer::to_json(raw_url, attributes)
        redis_key = key(token)
        if ttl
          client.setex(redis_key, ttl, content)
        else
          client.set(redis_key, content)
        end
      end

      def fetch(token)
        content = client.get(key(token))

        return {} unless content
        Shrinker::Serializer::from_json(content)
      end

      protected

      def client
        @client ||= begin
          ::Redis.new(@client_options)
        end
      end 

      def delete(token)
        client.del(key(token))
      end

      def clear!(pattern = nil)
        keys = client.keys("#{@namespace}::#{pattern || '*'}")
        client.del(*keys)
      end

      def key(token)
        [@namespace, token].compact.join('::')
      end
    end
  end
end