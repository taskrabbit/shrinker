module Shrinker
  module Serializer
    extend self

    def to_json(raw_url, attributes = {})
      to_hash(raw_url, attributes).to_json
    end

    def to_hash(raw_url, attributes = {})
      {:url => raw_url, :attributes => (attributes || {})}
    end

    # symbolize keys from the json if with_indifferent_access exists
    def from_json(content)
      hash = JSON.parse(content)
      hash = hash.with_indifferent_access if hash.respond_to?(:with_indifferent_access)
      hash
    end
  end
end