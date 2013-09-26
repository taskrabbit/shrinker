require 'spec_helper'

describe Shrinker::Token do
  describe "#generate" do
    before do
      Shrinker.config.reset!
      Shrinker::Token.stub(:rand).and_return('random')
    end

    after do
      Shrinker.config.reset!
    end
    
    it "should use the length config setting" do      
      Shrinker.configure do
        token_length_target 4
      end
      
      Digest::MD5.should_receive(:hexdigest).with("something").and_return("abcdefghijklmnopqrstuvwxyz")
      Shrinker::Token.generate(0, prefix: 'something').should == "wxyz"
    end
    
    it "should use longer than defualt if that is the strategy (default)" do
      Shrinker.configure do
        token_length_target 4
      end
      
      Digest::MD5.should_receive(:hexdigest).with("something").and_return("abcdefghijklmnopqrstuvwxyz")
      Shrinker::Token.generate(1, prefix: 'something').should == "vwxyz"
    end
    
    it "should default to 6 length" do
      Digest::MD5.should_receive(:hexdigest).with("something").and_return("abcdefghijklmnopqrstuvwxyz")

      Shrinker::Token.generate(0, prefix: 'something').should == "uvwxyz"
    end
    
    it "should use the random strategy if asked" do
      Shrinker.configure do
        token_length_strategy :random
        token_length_target 6
      end
      
      Digest::MD5.should_receive(:hexdigest).with("something__random").and_return("abcdefghijklmnopqrstuvwxyz")
      Shrinker::Token.generate(0, prefix: 'something').should == "uvwxyz"
    end
    
    it "should not get longer if strategy random" do
      Shrinker.configure do
        token_length_strategy :random
        token_length_target 6
      end
      
      Digest::MD5.should_receive(:hexdigest).with("something__random").and_return("abcdefghijklmnopqrstuvwxyz")
      Shrinker::Token.generate(1, prefix: 'something').should == "uvwxyz"
    end
  end

  describe "#fetch_uniq_token" do
    let(:backend) { double }

    it "returns an unique token" do
      backend.stub(:used_token?).and_return(true, false)

      Shrinker::Token.should_receive(:generate).twice.and_return('abcdef')

      Shrinker::Token.fetch_unique_token(backend).should == 'abcdef'
    end
  end
end