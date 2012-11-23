require 'spec_helper'

describe Shrinker::Token do
  describe "#generate" do
    it "returns a string of SecureRandom hex" do
      SecureRandom.should_receive(:hex).with(6).and_return "thetoken"

      Shrinker::Token.generate.should == "thetoken"
    end
  end
end