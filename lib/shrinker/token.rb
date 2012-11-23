module Shrinker
  module Token
    require 'securerandom'

    extend self

    def generate
      SecureRandom.hex(6)
    end
  end
end