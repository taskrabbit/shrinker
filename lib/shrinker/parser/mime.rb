module Shrinker
  module Parser
    class Mime < Abstract
      require 'mail'

      def replace
        [email, email.all_parts].flatten.compact.each do |part|
          new_body  = Text::replace(part.body.decoded, attributes, config)
          part.body = if part.content_transfer_encoding
                        Mail::Body.new(new_body).encoded(part.content_transfer_encoding)
                      else
                        new_body.to_s
                      end
        end
        email.to_s
      end

      def email
        @email ||= Mail.read_from_string(content)
      end
    end
  end
end