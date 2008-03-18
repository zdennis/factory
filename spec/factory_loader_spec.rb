require File.dirname(__FILE__) + '/spec_helper'
require 'fileutils'

describe FactoryLoader, "#load" do
  def load
    FactoryLoader.new(CUSTOM_FACTORIES_DIR).load(SAMPLE_LIB_DIR)
  end
    
    it "creates a factory for each .rb file in the loaded directory" do
      load
      Object.const_defined?("CatFactory").should be_true
      Object.const_defined?("DogFactory").should be_true
    end
    
    it "creates a factory for each .rb object in sub-directories of the loaded directory" do
      load
      Object.const_defined?("GuppyFactory").should be_true
    end
    
    it "does not create a factory for .rb files in any custom factory directory" do
      load
      Object.const_defined?("AnimalFactory").should be_false
    end
  
  it "does not create a factory for .rb files in a sub-directory of any custom factory directory" do
    load
    Object.const_defined?("DolphinFactory").should be_false
  end
  
  describe "when a set of custom factory paths are given" do
    before(:all) do
      FileUtils.touch(SAMPLE_LIB_DIR + "/animal.rb")
      FileUtils.touch(CUSTOM_FACTORIES_DIR + "/animal_factory.rb")
    end
    
    after(:all) do
      FileUtils.rm(SAMPLE_LIB_DIR + "/animal.rb")
      FileUtils.rm(CUSTOM_FACTORIES_DIR + "/animal_factory.rb")
    end
    
    it "does not create a factory for the presenter" do
      load
      Object.const_defined?("AnimalFactory").should be_false
    end
  end
  
  describe "a created factory" do
    before(:all) do
      ::Person = stub("Person model")
      Dir["#{SAMPLE_LIB_DIR}/*.rb"].each{ |f| require f }
      load
    end
  
    describe '#create' do
      before do
        @object = mock "some new object"
        ::Dog.stub!(:new).and_return(@object)
      end
      
      it "creates a presenter passing along any options" do
        ::Dog.should_receive(:new).with(:foo => :bar)
        ::DogFactory.new.create(:foo => :bar)
      end
      
      it "returns the newly created presenter" do
        ::DogFactory.new.create.should == @object        
      end
    end
  end
end