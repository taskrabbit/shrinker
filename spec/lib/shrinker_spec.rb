require 'spec_helper'

describe Shrinker do
  describe ".unshrink" do
    it "delegates the method to the Extractor" do
      Shrinker::Extractor.should_receive(:unshrink).with('token', Shrinker.config)

      Shrinker.unshrink('token')
    end
  end
end