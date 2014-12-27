require 'spec_helper'

describe Shrinker::Parser::Url do
  describe "#replace" do
    before { allow(Shrinker::Token).to receive(:fetch_unique_token).and_return("thetoken") }

    context "without protocol" do
      let(:config) do
        config = Shrinker::Config.new
        config.instance_eval do
          backend         'Redis'
          expanded_pattern /(www\.)?google.com/
          exclude_path /images|assets/
          shrinked_pattern 'goo.ln'
        end
        config
      end

      it "replace the link" do
        expect(Shrinker::Parser::Url::replace("www.google.com?something=else", {:user_id => 10}, config)).to eql("goo.ln/thetoken")
      end

      it "store the old link" do
        expect_any_instance_of(Shrinker::Backend::Redis).to receive(:store).with("www.google.com?something=else", 'thetoken', {:user_id => 10})

        Shrinker::Parser::Url::replace("www.google.com?something=else", {:user_id => 10}, config)
      end

      describe "does not do anything" do
        before do
          expect_any_instance_of(Shrinker::Backend::Redis).to receive(:store).never
        end

        it "returns the text if it does not match an url" do
          expect(Shrinker::Parser::Url::replace("sometext", {}, config)).to eql("sometext")
        end

        it "returns the text if it does not match the domain" do
          expect(Shrinker::Parser::Url::replace("www.google.fr", {}, config)).to eql("www.google.fr")
        end

        it "does not replace the link if there is a shrinker=false" do
          expect(Shrinker::Parser::Url::replace("www.google.com?shrinker=false&something=else", {}, config)).to eql("www.google.com?something=else")
        end

        it "does not replace the link if its excluded" do
          expect(Shrinker::Parser::Url::replace("www.google.com/assets/logo.png?something=else", {}, config)).to eql("www.google.com/assets/logo.png?something=else")
        end
      end
    end

    context "with full url dynamic pattern" do
      let(:config) do
        config = Shrinker::Config.new
        config.instance_eval do
          backend         'Redis'
          expanded_pattern /(www\.)?google.com/
          shrinked_pattern lambda{ |m| "#{m[0]}/x"}
        end
        config
      end

      it "replace the link" do
        expect(Shrinker::Parser::Url::replace("www.google.com?something=else", {:user_id => 10}, config)).to eql("www.google.com/x/thetoken")
      end

      it "store the old link" do
        allow_any_instance_of(Shrinker::Backend::Redis).to receive(:store).with("www.google.com?something=else", 'thetoken', {:user_id => 10})

        Shrinker::Parser::Url::replace("www.google.com?something=else", {:user_id => 10}, config)
      end
    end

    context "with partial url dynamic pattern" do
      let(:config) do
        config = Shrinker::Config.new
        config.instance_eval do
          backend         'Redis'
          expanded_pattern /(.+)\.google\.com/
          shrinked_pattern lambda{ |m| "#{m[1]}.other.com"}
        end
        config
      end

      it "replace the link" do
        expect(Shrinker::Parser::Url::replace("xyz.google.com?something=else", {:user_id => 10}, config)).to eql("xyz.other.com/thetoken")
      end

      it "store the old link" do
        allow_any_instance_of(Shrinker::Backend::Redis).to receive(:store).with("www.google.com?something=else", 'thetoken', {:user_id => 10})

        Shrinker::Parser::Url::replace("www.google.com?something=else", {:user_id => 10}, config)
      end
    end

    context "with protocol" do
      let(:config) do
        config = Shrinker::Config.new
        config.instance_eval do
          backend         'Redis'
          expanded_pattern /http:\/\/(www\.)?google.com/
          shrinked_pattern 'https://goo.ln'
        end
        config
      end

      it "replace the link" do
        expect(Shrinker::Parser::Url::replace("http://www.google.com?something=else", {:user_id => 10}, config)).to eql("https://goo.ln/thetoken")
      end

      it "store the old link" do
        allow_any_instance_of(Shrinker::Backend::Redis).to receive(:store).with("http://www.google.com?something=else", 'thetoken', {:user_id => 10})

        Shrinker::Parser::Url::replace("http://www.google.com?something=else", {:user_id => 10}, config)
      end
    end
  end
end
