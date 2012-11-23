require 'spec_helper'

describe Shrinker::Parser::Url do
  let(:config) do
    config = Shrinker::Config.new
    config.instance_eval do
      backend         'Redis'
      expanded_domain /(www\.)?google.com/
      shrinked_domain 'goo.ln'
    end
    config
  end

  describe "#replace" do
    before { Shrinker::Token.stub(:generate).and_return("thetoken") }

    it "replace the link" do
      Shrinker::Parser::Url::replace("www.google.com?something=else", {:user_id => 10}, config).should == "goo.ln/thetoken"
    end

    it "store the old link" do
      Shrinker::Backend::Redis.any_instance.should_receive(:store).with("www.google.com?something=else", 'thetoken', {:user_id => 10})

      Shrinker::Parser::Url::replace("www.google.com?something=else", {:user_id => 10}, config)
    end

    describe "does not do anything" do
      before do
        Shrinker::Backend::Redis.any_instance.should_receive(:store).never
      end

      it "returns the text if it does not match an url" do
        Shrinker::Parser::Url::replace("sometext", {}, config).should == "sometext"
      end

      it "returns the text if it does not match the domain" do
        Shrinker::Parser::Url::replace("www.google.fr", {}, config).should == "www.google.fr"
      end

      it "does not replace the link if there is a shrinker=false" do
        Shrinker::Parser::Url::replace("www.google.com?shrinker=false&something=else", {}, config).should == "www.google.com?something=else"
      end
    end
  end
end