require 'spec_helper'

describe Shrinker::Config do

  module Shrinker
    module Backend
      class FakeBackend < ::Shrinker::Backend::Abstract

      end
    end
  end

  let(:config) { Shrinker.config }

  before do
    config.reset!
  end

  after do
    config.reset!
  end

  it 'should return the config object for manipulation' do
    config.is_a?(Shrinker::Config).should be_true
    Shrinker.configure.is_a?(Shrinker::Config).should be_true
  end

  it 'should yield to the config if a block is present' do
    lambda{
      Shrinker.configure do
        raise self.class.name
      end
    }.should raise_error('Shrinker::Config')
  end

  it 'allows passing the backend' do
    Shrinker.configure do
      backend 'FakeBackend'
      backend_options({:key => 'value'})
    end

    Shrinker::Backend::FakeBackend.should_receive(:new).with({:key => 'value'})
    Shrinker.send(:backend)
  end

  describe "#merge!" do
    it "merges a hash" do
      config.merge!(backend_options: {something: true})
      config.backend_options.should == {something: true}
    end

    it "merges an instance of Config" do
      config.instance_eval do
        expanded_pattern 'first_pattern'
        shrinked_pattern 'shrinked_pattern'
      end
      other_config = Shrinker::Config.new
      other_config.instance_eval do
        expanded_pattern 'second_pattern'
      end
      config.merge!(other_config)
      config.expanded_pattern.should == 'second_pattern'
      config.shrinked_pattern.should == 'shrinked_pattern'
    end
  end
end