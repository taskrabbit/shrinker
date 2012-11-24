module Shrinker
  module Parser
    class Mime < Abstract
      require 'mail'

      def replace
        [email, email.all_parts].flatten.compact.each do |part|
          part.body = Text::replace(part.body.decoded, attributes, config)
        end
        email.to_s
      end

      def email
        @email ||= Mail.read_from_string(content)
      end
    end
  end
end