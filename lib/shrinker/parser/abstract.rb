module Shrinker
  module Parser
    class Abstract < Struct.new(:content, :attributes, :config)
      # Delegate replace to an instance
      def self.replace(content, attributes = {}, config = nil)
        self.new(content, attributes, config).replace
      end

      def replace
        raise NotImplemented
      end

      protected

      def url_regex
        /(#{expanded_pattern}[-A-Z0-9+&@#\/%?=~_|$!:,.;]*[-A-Z0-9+&@#\/%=~_|$])/i
      end

      def excluded_regex
        config.exclude
      end

      def expanded_pattern
        config.expanded_pattern
      end

      def shrinked_pattern
        config.shrinked_pattern
      end

      def backend
        config.backend_instance
      end

      def config
        super || Shrinker.config
      end
    end
  end
end