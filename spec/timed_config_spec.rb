require 'spec_helper'

describe TimedConfig do
  it "should be sleeping" do
    TimedConfig.thread.status.should == 'sleep'
  end
  
  it "should not have set a config" do
    TimedConfig.config.should == nil
  end
  
  it "should set a config when path set" do
    TimedConfig.path = "#{$root}/spec/fixtures/config.yml"
    sleep 0.1
    TimedConfig.config.should == { 'test' => 'test' }
  end
end