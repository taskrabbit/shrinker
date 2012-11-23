module Shrinker
  module Parser
    class Abstract < Struct.new(:content, :options, :config)
      # Delegate replace to an instance
      def self.replace(content, options = {}, config = nil)
        self.new(content, options, config).replace
      end

      def replace(content, options = {}, config = nil)
        raise NotImplemented
      end

      protected

      def url_regex
        /(#{config.expanded_domain}[-A-Z0-9+&@#\/%?=~_|$!:,.;]*[-A-Z0-9+&@#\/%=~_|$])/i
      end

      def config
        super || Shrinker.config
      end
    end
  end
end