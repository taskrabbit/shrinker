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
      Here is a link to http://my-example.com/test?params=1

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
        expanded_pattern /(www\.)?my-example.com/
        shrinked_pattern 'goo.ln'
      end
      config
    end

    it "replace the content in the mime" do
      expect(Shrinker::Parser::Url).to receive(:replace).with('my-example.com/test?params=1', {}, config).and_return("replace1")
      expect(Shrinker::Parser::Url).to receive(:replace).with('somewebsite.com', {}, config).never

      replaced_mime = Shrinker::Parser::Mime::replace(mime, {}, config)
      expect(replaced_mime).to include("Here is a link to http://replace1")
    end

    context "when mime is multipart" do
      let(:mime) { File.read(File.join(FIXTURES_PATH, 'mime.txt')) }

      it "replace only anchor tags when setting anchors_only_in_html to true" do
        config.anchors_only_in_html true
        config.around_pattern /href="(?:https?:\/\/)?($url)"/

        expect(Shrinker::Parser::Url).to receive(:replace).with("my-example.com/a?something=true", {}, config).and_return('replace1')
        expect(Shrinker::Parser::Url).to receive(:replace).with("www.my-example.com/donec-lobortis-lacus-vel-urna-variuo--4?clicked=abcdef", {}, config).and_return('replace2')
        expect(Shrinker::Parser::Url).to receive(:replace).with('www.my-example.com/class-aptent-taciti-sociosqu-ad-litader.jpg', {}, config).never
        expect(Shrinker::Parser::Url).to receive(:replace).with('www.my-example.com/safe', {}, config).never
        expect(Shrinker::Parser::Url).to receive(:replace).with('my-example.com/none', {}, config).never

        replaced_mime = Shrinker::Parser::Mime::replace(mime, {}, config)
      end

      it "replace every urls when not setting anchors_only_in_html" do
        expect(Shrinker::Parser::Url).to receive(:replace).with("my-example.com/a?something=true", {}, config).and_return('replace1')
        expect(Shrinker::Parser::Url).to receive(:replace).with("www.my-example.com/donec-lobortis-lacus-vel-urna-variuo--4?clicked=abcdef", {}, config).and_return('replace2')
        expect(Shrinker::Parser::Url).to receive(:replace).with('www.my-example.com/class-aptent-taciti-sociosqu-ad-litader.jpg', {}, config).and_return('replace3')
        expect(Shrinker::Parser::Url).to receive(:replace).with('www.my-example.com/safe', {}, config).and_return('replace4')
        expect(Shrinker::Parser::Url).to receive(:replace).with('my-example.com/none', {}, config).and_return('replace5')

        replaced_mime = Shrinker::Parser::Mime::replace(mime, {}, config)
      end
    end
  end

  context "for longer multipart mimes" do

    let(:multipart_mime) { File.read(File.join(FIXTURES_PATH, 'multipart_mime.txt')) }
    let(:config) do
      config = Shrinker::Config.new
      config.instance_eval do
        backend 'Redis'
        expanded_pattern /www.somwebsite.com/
        exclude_path /core|assets/
        shrinked_pattern 'goo.ln'
      end
      config
    end

    it "replace only anchor tags when setting anchors_only_in_html to true" do
      config.anchors_only_in_html true

      config_for_html = config.dup
      config_for_html.around_pattern /href="(?:https?:\/\/)?($url)"/

      expect(Shrinker::Parser::Url).to receive(:replace).with("www.somwebsite.com/glencoe-il/t/office-help--0000", {}, config).and_return('replace1')
      expect(Shrinker::Parser::Url).to receive(:replace).with("www.somwebsite.com/notifications", {}, config).and_return('replace2')
      expect(Shrinker::Parser::Url).to receive(:replace).with("www.somwebsite.com/go/defdbf1191f17112776a6adb4c201b277af845278971e81b532089d1b96926300347343b15580afba7a7cc41567b9608161d", {}, config_for_html).and_return('replace3')
      expect(Shrinker::Parser::Url).to receive(:replace).with("www.somwebsite.com/go/5f25b2b15ec6b450c3c5af71102616e07413381a718f1b5d21e7ff9e26d6fc216e9c05ab2b8a40195a16c8603be5860170eb", {}, config_for_html).and_return('replace4')
      expect(Shrinker::Parser::Url).to receive(:replace).with('www.somwebsite.com/core/assets/email/somwebsite-sky-header.jpg', {}, config_for_html).never

      replaced_mime = Shrinker::Parser::Mime::replace(multipart_mime, {}, config)
    end

    it "replace every urls when not setting anchors_only_in_html" do
      expect(Shrinker::Parser::Url).to receive(:replace).with("www.somwebsite.com/glencoe-il/t/office-help--0000", {}, config).and_return('replace1')
      expect(Shrinker::Parser::Url).to receive(:replace).with("www.somwebsite.com/notifications", {}, config).and_return('replace2')
      expect(Shrinker::Parser::Url).to receive(:replace).with("www.somwebsite.com/go/defdbf1191f17112776a6adb4c201b277af845278971e81b532089d1b96926300347343b15580afba7a7cc41567b9608161d", {}, config).and_return('replace3')
      expect(Shrinker::Parser::Url).to receive(:replace).with("www.somwebsite.com/go/5f25b2b15ec6b450c3c5af71102616e07413381a718f1b5d21e7ff9e26d6fc216e9c05ab2b8a40195a16c8603be5860170eb", {}, config).and_return('replace4')
      expect(Shrinker::Parser::Url).to receive(:replace).with('www.somwebsite.com/core/assets/email/somwebsite-sky-header.jpg', {}, config).never

      replaced_mime = Shrinker::Parser::Mime::replace(multipart_mime, {}, config)
    end

  end

end
