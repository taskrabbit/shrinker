module Shrinker
  module Parser
    class Url < Abstract
      def replace
        return url.to_s if url.params.delete(:shrinker).to_s == 'false'
        return url.to_s if url =~ excluded_path_regex

        new_url = url.to_s
        new_url = shrink if url =~ url_regex

        new_url
      end

      def shrink
        token = Token.generate
        backend.store(content, token, attributes)
        [shrinked_pattern, token].join("/")
      end

      def url
        @url ||= EasyUrl.new(content)
      end
    end
  end
end