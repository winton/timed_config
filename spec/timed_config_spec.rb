require 'spec_helper'

describe TimedConfig do
  
  after(:all) do
    FileUtils.rm "#{$root}/spec/fixtures/config.yml"
  end
  
  it "should not have set a config" do
    TimedConfig.config.should == nil
  end
  
  it "should update config when path set" do
    write_to_fixture "test: test"
    TimedConfig.path = "#{$root}/spec/fixtures/config.yml"
    TimedConfig.config.should == { 'test' => 'test' }
  end
  
  it "should update config when period set" do
    write_to_fixture "test2: test2"
    TimedConfig.period = 2
    TimedConfig.config.should == { 'test2' => 'test2' }
  end
  
  it "should not update config in one second" do
    write_to_fixture "test3: test3"
    sleep 1
    TimedConfig.config.should == { 'test2' => 'test2' }
  end
  
  it "should update config in two seconds" do
    sleep 1
    TimedConfig.config.should == { 'test3' => 'test3' }
  end
end