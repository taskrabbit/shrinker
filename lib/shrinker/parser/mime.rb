module Shrinker
  module Parser
    class Mime < Abstract
      require 'mail'

      def replace
        parts = email.all_parts.empty? ? [email] : email.all_parts

        parts.each do |part|
          new_body  = replace_part_body(part)
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

      def replace_part_body(part)
        replace_config = config.dup
        if part.mime_type == "text/html" && anchors_only_in_html? 
          replace_config.merge!({:around_pattern => anchor_tag_around_regex})
        end

        Text::replace(part.body.decoded, attributes, replace_config)
      end

      private 

      def anchor_tag_around_regex
        /href="(?:https?:\/\/)?($url)"/
      end

      def anchors_only_in_html?
        config.anchors_only_in_html == true
      end
    end
  end
end