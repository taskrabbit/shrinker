require 'spec_helper'

describe Shrinker::Token do
  describe "#generate" do
    it "allows passing a prefix" do
      Shrinker::Token.stub(:rand).and_return('random')
      Digest::MD5.should_receive(:hexdigest).with("something__random").and_return("abcdefghijklmnopqrstuvwxyz")

      Shrinker::Token.generate(prefix: 'something').should == "opqrstuvwxyz"
    end
  end

  describe "#fetch_uniq_token" do
    let(:backend) { stub }

    it "returns an unique token" do
      backend.stub(:used_token?).and_return(true, false)

      Shrinker::Token.should_receive(:generate).twice.and_return('abcdef')

      Shrinker::Token.fetch_unique_token(backend).should == 'abcdef'
    end
  end
end