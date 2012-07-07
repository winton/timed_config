require 'spec_helper'

describe TimedConfig::Gems do
  
  before(:each) do
    @old_config = TimedConfig::Gems.config
    
    TimedConfig::Gems.config.gemspec = "#{$root}/spec/fixtures/gemspec.yml"
    TimedConfig::Gems.config.gemsets = [
      "#{$root}/spec/fixtures/gemsets.yml"
    ]
    TimedConfig::Gems.config.warn = true
    
    TimedConfig::Gems.gemspec true
    TimedConfig::Gems.gemset = nil
  end
  
  after(:each) do
    TimedConfig::Gems.config = @old_config
  end
  
  describe :activate do
    it "should activate gems" do
      TimedConfig::Gems.stub!(:gem)
      TimedConfig::Gems.should_receive(:gem).with('rspec', '=1.3.1')
      TimedConfig::Gems.should_receive(:gem).with('rake', '=0.8.7')
      TimedConfig::Gems.activate :rspec, 'rake'
    end
  end
  
  describe :gemset= do
    before(:each) do
      TimedConfig::Gems.config.gemsets = [
        {
          :name => {
            :rake => '>0.8.6',
            :default => {
              :externals => '=1.0.2'
            }
          }
        },
        "#{$root}/spec/fixtures/gemsets.yml"
      ]
    end
    
    describe :default do
      before(:each) do
        TimedConfig::Gems.gemset = :default
      end
      
      it "should set @gemset" do
        TimedConfig::Gems.gemset.should == :default
      end
    
      it "should set @gemsets" do
        TimedConfig::Gems.gemsets.should == {
          :name => {
            :rake => ">0.8.6",
            :default => {
              :externals => '=1.0.2',
              :mysql => "=2.8.1",
              :rspec => "=1.3.1"
            },
            :rspec2 => {
              :mysql2 => "=0.2.6",
              :rspec => "=2.3.0"
            },
            :solo => nil
          }
        }
      end
    
      it "should set Gems.versions" do
        TimedConfig::Gems.versions.should == {
          :externals => "=1.0.2",
          :mysql => "=2.8.1",
          :rake => ">0.8.6",
          :rspec => "=1.3.1"
        }
      end
      
      it "should return proper values for Gems.dependencies" do
        TimedConfig::Gems.dependencies.should be == [ :rake, :mysql ]
        TimedConfig::Gems.development_dependencies.should == []
      end
      
      it "should return proper values for Gems.gemset_names" do
        puts TimedConfig::Gems.gemset_names.class
        TimedConfig::Gems.gemset_names.should =~ [ :default, :rspec2, :solo ]
      end
    end
    
    describe :rspec2 do
      before(:each) do
        TimedConfig::Gems.gemset = "rspec2"
      end
      
      it "should set @gemset" do
        TimedConfig::Gems.gemset.should == :rspec2
      end
    
      it "should set @gemsets" do
        TimedConfig::Gems.gemsets.should == {
          :name => {
            :rake => ">0.8.6",
            :default => {
              :externals => '=1.0.2',
              :mysql => "=2.8.1",
              :rspec => "=1.3.1"
            },
            :rspec2 => {
              :mysql2=>"=0.2.6",
              :rspec => "=2.3.0"
            },
            :solo => nil
          }
        }
      end
    
      it "should set Gems.versions" do
        TimedConfig::Gems.versions.should == {
          :mysql2 => "=0.2.6",
          :rake => ">0.8.6",
          :rspec => "=2.3.0"
        }
      end
      
      it "should return proper values for Gems.dependencies" do
        TimedConfig::Gems.dependencies.should be == [ :rake, :mysql2 ]
        TimedConfig::Gems.development_dependencies.should == []
      end
      
      it "should return proper values for Gems.gemset_names" do
        TimedConfig::Gems.gemset_names.should =~ [ :default, :rspec2, :solo ]
      end
    end
    
    describe :solo do
      before(:each) do
        TimedConfig::Gems.gemset = :solo
      end
      
      it "should set @gemset" do
        TimedConfig::Gems.gemset.should == :solo
      end
    
      it "should set @gemsets" do
        TimedConfig::Gems.gemsets.should == {
          :name => {
            :rake => ">0.8.6",
            :default => {
              :externals => '=1.0.2',
              :mysql => "=2.8.1",
              :rspec => "=1.3.1"
            },
            :rspec2 => {
              :mysql2=>"=0.2.6",
              :rspec => "=2.3.0"
            },
            :solo => nil
          }
        }
      end
    
      it "should set Gems.versions" do
        TimedConfig::Gems.versions.should == {:rake=>">0.8.6"}
      end
      
      it "should return proper values for Gems.dependencies" do
        TimedConfig::Gems.dependencies.should be == [:rake]
        TimedConfig::Gems.development_dependencies.should == []
      end
      
      it "should return proper values for Gems.gemset_names" do
        TimedConfig::Gems.gemset_names.should =~ [ :default, :rspec2, :solo ]
      end
    end
    
    describe :nil do
      before(:each) do
        TimedConfig::Gems.gemset = nil
      end
      
      it "should set everything to nil" do
        TimedConfig::Gems.gemset.should be == nil
        TimedConfig::Gems.gemsets.should be == nil
        TimedConfig::Gems.versions.should == nil
      end
    end
  end
  
  describe :gemset_from_loaded_specs do
    before(:each) do
      Gem.stub!(:loaded_specs)
    end
    
    it "should return the correct gemset for name gem" do
      Gem.should_receive(:loaded_specs).and_return({ "name" => nil })
      TimedConfig::Gems.send(:gemset_from_loaded_specs).should == :default
    end
    
    it "should return the correct gemset for name-rspec gem" do
      Gem.should_receive(:loaded_specs).and_return({ "name-rspec2" => nil })
      TimedConfig::Gems.send(:gemset_from_loaded_specs).should == :rspec2
    end
  end
  
  describe :reload_gemspec do
    it "should populate @gemspec" do
      TimedConfig::Gems.gemspec.hash.should == {
        "name" => "name",
        "version" => "0.1.0",
        "authors" => ["Author"],
        "email" => "email@email.com",
        "homepage" => "http://github.com/author/name",
        "summary" => "Summary",
        "description" => "Description",
        "dependencies" => [
          "rake",
          { "default" => [ "mysql" ] },
          { "rspec2" => [ "mysql2" ] }
        ],
        "development_dependencies" => nil
       }
    end
  
    it "should create methods from keys of @gemspec" do
      TimedConfig::Gems.gemspec.name.should be == "name"
      TimedConfig::Gems.gemspec.version.should be == "0.1.0"
      TimedConfig::Gems.gemspec.authors.should be == ["Author"]
      TimedConfig::Gems.gemspec.email.should be == "email@email.com"
      TimedConfig::Gems.gemspec.homepage.should be == "http://github.com/author/name"
      TimedConfig::Gems.gemspec.summary.should be == "Summary"
      TimedConfig::Gems.gemspec.description.should be == "Description"
      TimedConfig::Gems.gemspec.dependencies.should be == [
        "rake",
        { "default" => ["mysql"] },
        { "rspec2" => [ "mysql2" ] }
      ]
      TimedConfig::Gems.gemspec.development_dependencies.should == nil
    end
  
    it "should produce a valid gemspec" do
      TimedConfig::Gems.gemset = :default
      gemspec = File.expand_path("../../../timed_config.gemspec", __FILE__)
      gemspec = eval(File.read(gemspec), binding, gemspec)
      gemspec.validate.should == true
    end
  end
end