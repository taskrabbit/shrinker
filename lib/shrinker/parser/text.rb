module Shrinker
  module Parser
    class Text < Abstract
      def replace
        content.gsub(url_regex) do |url|
          shrink_url(url)
        end
      end

      protected

      def shrink_url(url)
        Url::replace(url, options, config)
      end
    end
  end
end