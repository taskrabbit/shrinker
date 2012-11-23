require 'spec_helper'

describe Shrinker::Backend::Redis do
  subject { Shrinker::Backend::Redis.new }

  describe "with options" do
    let(:options) do
      {
        :client => {
          :login    => 'login',
          :password => 'somepassword',
          :port     => '2331',
          :host     => 'localhost'
        }
      }
    end

    subject { Shrinker::Backend::Redis.new(options) }

    it "uses the options" do
      Redis.should_receive(:new).with(options[:client])

      subject.send(:client)
    end
  end

  describe "#store" do
    let(:client) { Redis.new }
    before { subject.stub(:client) { client} }

    it "stores the raw_url with the token key" do
      Shrinker::Serializer.should_receive(:to_json).with('someurl', {}).and_return("tobestored")

      subject.store('someurl', 'token')

      client.get("_shrinker::token").should == 'tobestored'
    end

    it "stores the raw_url with the attributes" do
      Shrinker::Serializer.should_receive(:to_json).with('someurl', {:user_id => 123}).and_return("tobestored")

      subject.store('someurl', 'token', :user_id => 123)
      client.get("_shrinker::token").should == 'tobestored'
    end

    it "sets the ttl when present" do
      Shrinker::Serializer.should_receive(:to_json).with('someurl', {}).and_return("tobestored")
      subject.stub(:ttl) { 32 }
      client.should_receive(:setex).with("_shrinker::token", 32, "tobestored")

      subject.store('someurl', 'token')
    end
  end

  describe "#fetch" do
    let(:client) { Redis.new }
    before { subject.stub(:client) { client} }

    it "fetches using the token key" do
      client.set("_shrinker::token", '{"url": "someurl", "attributes": {}}')
      subject.fetch("token").should == {'url' => "someurl", 'attributes' => {}}
    end
  end
end