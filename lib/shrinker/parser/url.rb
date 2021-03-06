module Shrinker
  module Parser
    class Url < Abstract
      def replace
        return url.to_s if url.params.delete(:shrinker).to_s == 'false'
        return url.to_s if url =~ excluded_path_regex

        new_url = url.to_s
        new_url = shrink if new_url =~ url_regex

        new_url
      end

      def shrink
        token = Token.fetch_unique_token(backend, prefix: "__#{attributes.to_json}__#{content}")
        backend.store(content, token, attributes)

        if shrinked_pattern.respond_to?(:call)
          if match = url.to_s.match(expanded_pattern)
            start = shrinked_pattern.call(match)
          else
            # just bail out
            return url.to_s
          end
        else
          start = shrinked_pattern.to_s
        end
        
        [start, token].join("/")
      end

      def url
        @url ||= EasyUrl.new(content)
      end

      def url_regex
        base_url_regex
      end
    end
  end
end