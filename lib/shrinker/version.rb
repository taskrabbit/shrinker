module Shrinker
  module VERSION

    MAJOR = 0
    MINOR = 1
    PATCH = 1
    PRE   = nil

    def self.to_s
      [MAJOR, MINOR, PATCH, PRE].compact.join('.')
    end
  end
end
