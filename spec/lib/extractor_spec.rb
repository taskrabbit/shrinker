require 'spec_helper'
require 'redis'

describe Shrinker::Extractor do
  describe "#url" do
    let(:config) do
      config = Shrinker::Config.new
      config.instance_eval do
        backend 'Redis'
      end
      config
    end

    let(:client) { Redis.new }

    before { client.set("_shrinker::token", '{"url": "someurl", "attributes": {"test": "ab"}}') }

    it "returns an EasyUrl instance" do
      easy_url = Shrinker::Extractor.unshrink("token", config)
      expect(easy_url).to be_instance_of(Shrinker::EasyUrl)
      expect(easy_url.to_s).to eql("someurl")
      expect(easy_url.attributes).to eql({"test" => 'ab'})
    end

    it "raise UrlNotFound when not existing" do
      expect {
        Shrinker::Extractor.unshrink("not-exiting", config)
      }.to raise_error(Shrinker::UrlNotFound)
    end
  end

  describe "#config" do
    it "returns the default config by default" do
      expect(Shrinker::Extractor.new.send(:config)).to eql Shrinker.config
    end
  end
end
