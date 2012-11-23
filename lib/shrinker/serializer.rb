module Shrinker
  module Serializer
    extend self

    def to_json(raw_url, attributes = {})
      to_hash(raw_url, attributes).to_json
    end

    def to_hash(raw_url, attributes = {})
      {:url => raw_url, :attributes => (attributes || {})}
    end
  end
end