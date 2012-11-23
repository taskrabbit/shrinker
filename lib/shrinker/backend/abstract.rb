module Shrinker
  module Backend
    class Abstract
      def initialize(options = {})
        @options = options
      end

      def record(raw_link, shrinked_link)
        raise NotImplemented
      end

      def fetch(token)
        raise NotImplemented
      end
    end
  end
end