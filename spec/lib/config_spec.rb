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
end