module Shrinker
  module Token
    require 'digest/md5'

    extend self

    def fetch_unique_token(backend, options = {})
      need_token = true

      round = 0
      while need_token
        token      = generate(round, options)
        need_token = backend.used_token?(token)
        round += 1
      end

      token
    end

    def generate(round, options = {})
      length   = Shrinker.config.token_length_target || 6
      strategy = Shrinker.config.token_length_strategy || "longer"

      prefix = options[:prefix].to_s
      if !prefix || prefix.length == 0
        # need soemthing
        prefix = rand(99999999).to_s
      end

      extra = ""
      if strategy.to_s == "random"
        extra= "__#{rand(99999999999)}"
      else
        length += round
      end

      content = Digest::MD5.hexdigest("#{prefix}#{extra}")
      content[-1*length..-1] || content
    end
  end
end
