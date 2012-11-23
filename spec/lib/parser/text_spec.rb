require 'spec_helper'

describe Shrinker::Parser::Text do
  let(:config) do
    config = Shrinker::Config.new
    config.instance_eval do
      expanded_domain /(www\.)?google.com/
      shrinked_domain 'goo.ln'
    end
    config
  end

  describe "#replace" do
    it "replaces proper occurences" do

      content = <<-EV
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
        Nunc quis rutrum http://www.google.com?something=true&else=false dolor. 
        Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.
        Curabitur ullamcorper nisl non dolor http://google.fr?something=true venenatis consequat.
        Morbi odio libero, tincidunt quis tempus a, fringilla vitae augue.
        http://google.com/somepath?something=true
        Aenean placerat ullamcorper lorem vel feugiat.
      EV

      Shrinker::Parser::Url.should_receive(:replace).with('www.google.com?something=true&else=false', {}, config).and_return("replace1")
      Shrinker::Parser::Url.should_receive(:replace).with('google.fr?something=true', {}, config).never
      Shrinker::Parser::Url.should_receive(:replace).with('google.com/somepath?something=true', {}, config).and_return("replace2")

      replaced_text = Shrinker::Parser::Text::replace(content, {}, config)

      expected_replaced_text = <<-EV
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
        Nunc quis rutrum http://replace1 dolor. 
        Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.
        Curabitur ullamcorper nisl non dolor http://google.fr?something=true venenatis consequat.
        Morbi odio libero, tincidunt quis tempus a, fringilla vitae augue.
        http://replace2
        Aenean placerat ullamcorper lorem vel feugiat.
      EV

      replaced_text.should == expected_replaced_text
    end

    it "does not do anything when there is no occurence" do
      content = <<-EV
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
        Curabitur ullamcorper nisl non dolor http://google.fr?something=true venenatis consequat.
        Aenean placerat ullamcorper lorem vel feugiat.
      EV

      replaced_text = Shrinker::Parser::Text::replace(content, {}, config)
      replaced_text.should == content
    end
  end
end