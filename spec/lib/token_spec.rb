require 'spec_helper'

describe Shrinker::Token do
  describe "#generate" do
    it "returns a string of SecureRandom hex" do
      SecureRandom.should_receive(:hex).with(6).and_return "thetoken"

      Shrinker::Token.generate.should == "thetoken"
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