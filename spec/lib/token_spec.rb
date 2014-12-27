require 'spec_helper'

describe Shrinker::Token do
  describe "#generate" do
    before do
      Shrinker.config.reset!
      allow(Shrinker::Token).to receive(:rand).and_return('random')
    end

    after do
      Shrinker.config.reset!
    end

    it "should use the length config setting" do
      Shrinker.configure do
        token_length_target 4
      end

      allow(Digest::MD5).to receive(:hexdigest).with("something").and_return("abcdefghijklmnopqrstuvwxyz")
      expect(Shrinker::Token.generate(0, prefix: 'something')).to eql("wxyz")
    end

    it "should use longer than defualt if that is the strategy (default)" do
      Shrinker.configure do
        token_length_target 4
      end

      allow(Digest::MD5).to receive(:hexdigest).with("something").and_return("abcdefghijklmnopqrstuvwxyz")
      expect(Shrinker::Token.generate(1, prefix: 'something')).to eql("vwxyz")
    end

    it "should default to 6 length" do
      allow(Digest::MD5).to receive(:hexdigest).with("something").and_return("abcdefghijklmnopqrstuvwxyz")

      expect(Shrinker::Token.generate(0, prefix: 'something')).to eql("uvwxyz")
    end

    it "should use the random strategy if asked" do
      Shrinker.configure do
        token_length_strategy :random
        token_length_target 6
      end

      allow(Digest::MD5).to receive(:hexdigest).with("something__random").and_return("abcdefghijklmnopqrstuvwxyz")
      expect(Shrinker::Token.generate(0, prefix: 'something')).to eql("uvwxyz")
    end

    it "should not get longer if strategy random" do
      Shrinker.configure do
        token_length_strategy :random
        token_length_target 6
      end

      allow(Digest::MD5).to receive(:hexdigest).with("something__random").and_return("abcdefghijklmnopqrstuvwxyz")
      expect(Shrinker::Token.generate(1, prefix: 'something')).to eql("uvwxyz")
    end
  end

  describe "#fetch_uniq_token" do
    let(:backend) { double }

    it "returns an unique token" do
      allow(backend).to receive(:used_token?).and_return(true, false)

      allow(Shrinker::Token).to receive(:generate).twice.and_return('abcdef')

      expect(Shrinker::Token.fetch_unique_token(backend)).to eql('abcdef')
    end
  end
end
