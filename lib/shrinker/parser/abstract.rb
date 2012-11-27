module Shrinker
  module Parser
    class Abstract < Struct.new(:content, :attributes)
      attr_reader :config

      # Delegate replace to an instance
      def self.replace(content, attributes = {}, config = nil)
        self.new(content, attributes, config).replace
      end

      def initialize(content = nil, attributes = nil, config = nil)
        super(content, attributes)
        merge_config(config)
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

      def merge_config(config)
        @config ||= Shrinker.config.dup
        @config.merge!(config)
      end
    end
  end
end