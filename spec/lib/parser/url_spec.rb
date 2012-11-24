require 'spec_helper'

describe Shrinker::Parser::Url do
  describe "#replace" do
    before { Shrinker::Token.stub(:generate).and_return("thetoken") }

    context "without protocol" do
      let(:config) do
        config = Shrinker::Config.new
        config.instance_eval do
          backend         'Redis'
          expanded_domain /(www\.)?google.com/
          exclude /images|assets/
          shrinked_domain 'goo.ln'
        end
        config
      end

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

        it "does not replace the link if its excluded" do
          Shrinker::Parser::Url::replace("www.google.com/assets/logo.png?something=else", {}, config).should == "www.google.com/assets/logo.png?something=else"
        end
      end
    end

    context "with protocol" do
      let(:config) do
        config = Shrinker::Config.new
        config.instance_eval do
          backend         'Redis'
          expanded_domain /http:\/\/(www\.)?google.com/
          shrinked_domain 'https://goo.ln'
        end
        config
      end

      it "replace the link" do
        Shrinker::Parser::Url::replace("http://www.google.com?something=else", {:user_id => 10}, config).should == "https://goo.ln/thetoken"
      end

      it "store the old link" do
        Shrinker::Backend::Redis.any_instance.should_receive(:store).with("http://www.google.com?something=else", 'thetoken', {:user_id => 10})

        Shrinker::Parser::Url::replace("http://www.google.com?something=else", {:user_id => 10}, config)
      end
    end
  end
end