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
      easy_url.should be_instance_of(Shrinker::EasyUrl)
      easy_url.to_s.should       == "someurl"
      easy_url.attributes.should == {"test" => 'ab'}
    end

    it "raise UrlNotFound when not existing" do
      expect {
        Shrinker::Extractor.unshrink("not-exiting", config)
      }.to raise_error(Shrinker::UrlNotFound)
    end
  end

  describe "#config" do
    it "returns the default config by default" do
      Shrinker::Extractor.new.send(:config).should == Shrinker.config
    end
  end
end