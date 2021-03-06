module Shrinker
  module Parser
    class Text < Abstract
      def replace
        content.gsub(url_regex) do |url|
          matched_url = $1

          next if matched_url =~ excluded_path_regex

          url.gsub!(matched_url, shrink_url(matched_url))
        end
      end

      protected

      def shrink_url(url)
        Url::replace(url, attributes, config)
      end
    end
  end
end
