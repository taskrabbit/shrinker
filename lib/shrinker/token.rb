module Shrinker
  module Token
    require 'securerandom'

    extend self

    def fetch_unique_token(backend)
      need_token = true

      while need_token
        token      = generate
        need_token = backend.used_token?(token)
      end

      token
    end

    def generate
      SecureRandom.hex(6)
    end
  end
end