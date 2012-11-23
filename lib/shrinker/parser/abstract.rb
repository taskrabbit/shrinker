module Shrinker
  module Parser
    class Abstract < Struct.new(:content, :attributes, :config)
      # Delegate replace to an instance
      def self.replace(content, attributes = {}, config = nil)
        self.new(content, attributes, config).replace
      end

      def replace(content, attributes = {}, config = nil)
        raise NotImplemented
      end

      protected

      def url_regex
        /(#{expanded_domain}[-A-Z0-9+&@#\/%?=~_|$!:,.;]*[-A-Z0-9+&@#\/%=~_|$])/i
      end

      def expanded_domain
        config.expanded_domain
      end

      def shrinked_domain
        config.shrinked_domain
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