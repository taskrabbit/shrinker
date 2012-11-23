module Shrinker
  module Parser
    class Url < Abstract
      def replace
        return url.to_s if url.params.delete(:shrinker).to_s == 'false'

        new_url = url.to_s
        new_url = shrink if url.to_s =~ url_regex

        new_url
      end

      def shrink
        token = Token.generate
        backend.store(content, token, attributes)
        [shrinked_domain, token].join("/")
      end

      def url
        @url ||= EasyUrl.new(content)
      end
    end
  end
end