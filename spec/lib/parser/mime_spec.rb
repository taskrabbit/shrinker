require 'spec_helper'

describe Shrinker::Parser::Mime do
  let(:mime) do
    <<-MYMIME
      Date: Fri, 23 Nov 2012 16:19:10 -0800
      To: someone@example.com
      From: else@example.com
      Subject: Email test
      Content-type: multipart/mixed; boundary="theBoundaryString"

      --theBoundaryString

      Plain text message goes in this part. Notice that it
      has a blank line before it starts, meaning that this
      part has no additional headers. 
      Here is a link to http://google.com/test?params=1

      --theBoundaryString
      Content-Type: text/html
      Content-Transfer-Encoding: 7bit
      Content-Disposition: inline
      Content-Base: "http://somewebsite.com/"

      <body><font size=4>This</font> is a 
      <i>test</i>.
      --theBoundaryString--
    MYMIME
  end

  describe "#replace" do
    let(:config) do
      config = Shrinker::Config.new
      config.instance_eval do
        expanded_pattern /(www\.)?google.com/
        shrinked_pattern 'goo.ln'
      end
      config
    end

    it "replace the content in the mime" do
      Shrinker::Parser::Url.should_receive(:replace).with('google.com/test?params=1', {}, config).and_return("replace1")
      Shrinker::Parser::Url.should_receive(:replace).with('somewebsite.com', {}, config).never

      replaced_mime = Shrinker::Parser::Mime::replace(mime, {}, config)
      replaced_mime.should include("Here is a link to http://replace1")
    end
  end
end