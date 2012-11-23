require 'spec_helper'

describe Shrinker::Serializer do
  describe "#hash" do
    it "returns a hash containing the url" do
      Shrinker::Serializer::to_hash('someurl').should == {:url => 'someurl', :attributes => {}}
    end

    it "returns a hash containing the attributes" do
      Shrinker::Serializer::to_hash('someurl', {:user_id => 12}).should == {:url => 'someurl', :attributes => {:user_id => 12}}
    end
  end

  describe "#json" do
    it "returns a json containing the url" do
      Shrinker::Serializer::to_json('someurl').should == {:url => 'someurl', :attributes => {}}.to_json
    end

    it "returns a json containing the attributes" do
      Shrinker::Serializer::to_json('someurl', {:user_id => 12}).should == {:url => 'someurl', :attributes => {:user_id => 12}}.to_json
    end
  end
end