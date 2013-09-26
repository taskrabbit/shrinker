module Shrinker
  module Backend
    class Abstract
      attr_reader :options

      def initialize(options = {})
        @options = options
      end

      def store(raw_url, token, attributes = {})
        raise "Shrinker::Backend::Abstract.store not implemented"
      end

      def fetch(token)
        raise "Shrinker::Backend::Abstract.fetch not implemented"
      end

      private

      def ttl
        options[:expires_in]
      end
    end
  end
end