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
        return base_url_regex if around_pattern.to_s == ''

        around_pattern.call(base_url_regex)
      end

      def base_url_regex
        /(#{expanded_pattern}[-A-Z0-9+&@#\/%?=~_|$!:,.;]*[-A-Z0-9+&@#\/%=~_|$])/i
      end

      def excluded_path_regex
        config.exclude_path
      end

      def expanded_pattern
        config.expanded_pattern
      end

      def around_pattern
        config.around_pattern
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