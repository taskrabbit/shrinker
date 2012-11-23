require 'spec_helper'

describe Shrinker do
  describe ".unshrink" do
    it "delegates the method to the Extractor" do
      extractor = stub
      Shrinker.stub(:extractor).and_return(extractor)
      extractor.should_receive(:unshrink).with('token')

      Shrinker.unshrink('token')
    end
  end

  describe ".extractor" do
    it "returns a new instance of Shrinker::Extractor" do
      Shrinker.send(:extractor).should be_instance_of(Shrinker::Extractor)
    end
  end
end