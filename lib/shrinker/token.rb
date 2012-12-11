module Shrinker
  module Token
    require 'digest/md5'

    extend self

    def fetch_unique_token(backend, options = {})
      need_token = true

      while need_token
        token      = generate(options)
        need_token = backend.used_token?(token)
      end

      token
    end

    def generate(options = {})
      prefix = options[:prefix]
      Digest::MD5.hexdigest("#{prefix}__#{rand(99999)}")[-12..-1]
    end
  end
end