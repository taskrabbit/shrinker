module Shrinker
  module Backend
    class Abstract
      attr_reader :options

      def initialize(options = {})
        @options = options
      end

      def store(raw_url, token, attributes = {})
        raise NotImplemented
      end

      def fetch(token)
        raise NotImplemented
      end

      private

      def ttl
        options[:expires_in]
      end
    end
  end
end