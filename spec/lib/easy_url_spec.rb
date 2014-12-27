require 'spec_helper'

describe Shrinker::EasyUrl do
  describe "#to_s" do
    it "returns itself with no params" do
      expect(Shrinker::EasyUrl.new("test").to_s).to eql('test')
    end

    it "returns itself with params" do
      expect(Shrinker::EasyUrl.new("test?something=2").to_s).to eql('test?something=2')
    end

    it "returns itself without the params when deleting it" do
      easy_url = Shrinker::EasyUrl.new("test?something=2")
      easy_url.params.delete(:something)
      expect(easy_url.to_s).to eql('test')
    end

    it "keeps the other params when deleting some" do
      easy_url = Shrinker::EasyUrl.new("test?something=2&else=3")
      easy_url.params.delete(:something)
      expect(easy_url.params[:else]).to eql('3')
      expect(easy_url.to_s).to eql('test?else=3')
    end
  end
end
