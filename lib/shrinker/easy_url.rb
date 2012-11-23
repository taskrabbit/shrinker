module Shrinker
  class EasyUrl < Struct.new(:url)
    require 'cgi'

    def to_s
      parsed_uri.query = to_query
      parsed_uri.query = nil if parsed_uri.query == ''
      parsed_uri.to_s
    end

    def params
      @params ||= begin
        hash = {}
        CGI.parse(parsed_uri.query).each_pair do |key, value|
          hash[key.to_sym] = value.length == 1 ? value.first : value
        end if parsed_uri.query
        hash
      end
    end

    protected

     def to_query
      return params.to_query if params.respond_to?(:to_query)
      params.collect { |key, value| "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}" }.join("&")
    end

    def parsed_uri
      @parsed_uri ||= URI.parse(url)
    end
  end
end