require 'spec_helper'

describe Shrinker::Parser::Text do
  describe "#replace" do

    context "without protocol" do
      let(:config) do
        config = Shrinker::Config.new
        config.instance_eval do
          expanded_pattern /(www\.)?google.com/
          shrinked_pattern  'goo.ln'
          around_pattern /href="(?:https?:\/\/)?($url)"/
        end
        config
      end

      it "replaces proper occurences" do
        content = <<-EV
          Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          Nunc quis rutrum <a href="http://www.google.com?something=true&else=false">dolor</a>.
          <a href="www.google.com?params=abcdef" style="text-align:center;">http://google.com/safe</a>
          Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.
          Curabitur ullamcorper nisl non dolor <a href="http://google.fr?something=true">venenatis</a> consequat.
          Morbi odio libero, tincidunt quis tempus a, fringilla vitae augue.
          <a href="http://google.com/somepath?something=true"></a>
          Aenean placerat ullamcorper lorem vel feugiat.
        EV

        allow(Shrinker::Parser::Url).to receive(:replace).with('www.google.com?something=true&else=false', {}, config).and_return("replace1")
        allow(Shrinker::Parser::Url).to receive(:replace).with('www.google.com?params=abcdef', {}, config).and_return("replace2")
        allow(Shrinker::Parser::Url).to receive(:replace).with('google.com/safe', {}, config).never
        allow(Shrinker::Parser::Url).to receive(:replace).with('google.fr?something=true', {}, config).never
        allow(Shrinker::Parser::Url).to receive(:replace).with('google.com/somepath?something=true', {}, config).and_return("replace3")

        replaced_text = Shrinker::Parser::Text::replace(content, {}, config)

        expected_replaced_text = <<-EV
          Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          Nunc quis rutrum <a href="http://replace1">dolor</a>.
          <a href="replace2" style="text-align:center;">http://google.com/safe</a>
          Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.
          Curabitur ullamcorper nisl non dolor <a href="http://google.fr?something=true">venenatis</a> consequat.
          Morbi odio libero, tincidunt quis tempus a, fringilla vitae augue.
          <a href="http://replace3"></a>
          Aenean placerat ullamcorper lorem vel feugiat.
        EV

        expect(replaced_text).to eql(expected_replaced_text)
      end

      it "does not do anything when there is no occurence" do
        content = <<-EV
          Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          Curabitur ullamcorper nisl non dolor http://google.fr?something=true venenatis consequat.
          Aenean placerat ullamcorper lorem vel feugiat.
        EV

        replaced_text = Shrinker::Parser::Text::replace(content, {}, config)
        expect(replaced_text).to eql(content)
      end
    end

    context "with protocol" do
      let(:config) do
        config = Shrinker::Config.new
        config.instance_eval do
          expanded_pattern /http:\/\/(www\.)?google.com/
          shrinked_pattern 'https://goo.ln'
        end
        config
      end

      it "replaces proper occurences" do
        content = <<-EV
          Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          Nunc quis rutrum http://www.google.com?something=true&else=false dolor.
          Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.
          Curabitur ullamcorper nisl non dolor http://google.fr?something=true venenatis consequat.
          Morbi odio libero, tincidunt quis tempus a, fringilla vitae augue.
          https://google.com/somepath?something=true
          Aenean placerat ullamcorper lorem vel feugiat.
        EV

        allow(Shrinker::Parser::Url).to receive(:replace).with('http://www.google.com?something=true&else=false', {}, config).and_return("https://replace1")
        allow(Shrinker::Parser::Url).to receive(:replace).with('google.fr?something=true', {}, config).never
        allow(Shrinker::Parser::Url).to receive(:replace).with('http://google.com/somepath?something=true', {}, config).never

        replaced_text = Shrinker::Parser::Text::replace(content, {}, config)

        expected_replaced_text = <<-EV
          Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          Nunc quis rutrum https://replace1 dolor.
          Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.
          Curabitur ullamcorper nisl non dolor http://google.fr?something=true venenatis consequat.
          Morbi odio libero, tincidunt quis tempus a, fringilla vitae augue.
          https://google.com/somepath?something=true
          Aenean placerat ullamcorper lorem vel feugiat.
        EV

        expect(replaced_text).to eql(expected_replaced_text)
      end
    end
  end

  describe "#config" do
    it "returns the default config by default" do
      expect(Shrinker::Parser::Text.new.send(:config) == Shrinker.config).to eql(true)
    end
  end
end
