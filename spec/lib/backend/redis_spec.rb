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
      expect(Redis).to receive(:new).with(options[:client])

      subject.send(:client)
    end
  end

  context "with a default client setup" do
    let(:client) { Redis.new }
    before { allow(subject).to receive(:client) { client} }

    describe "#store" do
      it "stores the raw_url with the token key" do
        expect(Shrinker::Serializer).to receive(:to_json).with('someurl', {}).and_return("tobestored")

        subject.store('someurl', 'token')

        expect(client.get("_shrinker::token")).to eql 'tobestored'
      end

      it "stores the raw_url with the attributes" do
        expect(Shrinker::Serializer).to receive(:to_json).with('someurl', {:user_id => 123}).and_return("tobestored")

        subject.store('someurl', 'token', :user_id => 123)
        expect(client.get("_shrinker::token")).to eql 'tobestored'
      end

      it "sets the ttl when present" do
        expect(Shrinker::Serializer).to receive(:to_json).with('someurl', {}).and_return("tobestored")
        allow(subject).to receive(:ttl) { 32 }
        expect(client).to receive(:setex).with("_shrinker::token", 32, "tobestored")

        subject.store('someurl', 'token')
      end
    end

    describe "#fetch" do
      it "fetches using the token key" do
        client.set("_shrinker::token", '{"url": "someurl", "attributes": {}}')
        expect(subject.fetch("token")).to eql({'url' => "someurl", 'attributes' => {}})
      end
    end

    describe "#used_token?" do
      before { subject.send(:delete, 'token') }

      it "returns true when the token is used" do
        client.set("_shrinker::token", '{"url": "someurl", "attributes": {}}')

        expect(subject.used_token?('token')).to eql(true)
      end

      it "returns false" do
        expect(subject.used_token?('token')).to eql(false)
      end
    end
  end
end
