require 'spec_helper'

describe Shrinker::EasyUrl do
  describe "#to_s" do
    it "returns itself with no params" do
      Shrinker::EasyUrl.new("test").to_s.should == 'test'
    end

    it "returns itself with params" do
      Shrinker::EasyUrl.new("test?something=2").to_s.should == 'test?something=2'
    end

    it "returns itself without the params when deleting it" do
      easy_url = Shrinker::EasyUrl.new("test?something=2")
      easy_url.params.delete(:something)
      easy_url.to_s.should == 'test'
    end

    it "keeps the other params when deleting some" do
      easy_url = Shrinker::EasyUrl.new("test?something=2&else=3")
      easy_url.params.delete(:something)
      easy_url.params[:else].should == '3'
      easy_url.to_s.should == 'test?else=3'
    end
  end
end