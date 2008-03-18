require File.dirname(__FILE__) + '/spec_helper'
require 'fileutils'

describe FactoryLoader, "#load" do
  it "creates a factory for each presenter in the specified folder" do
    FactoryLoader.load(File.dirname(__FILE__) + "/sample_objects")
    Object.const_defined?("CatFactory").should be_true
    Object.const_defined?("DogFactory").should be_true
  end
  
  describe "when a factory already exists in the RAILS_ROOT/app/factories/ directory" do
    before(:all) do
      FileUtils.touch(File.dirname(__FILE__) + "/sample_objects/animal.rb")
      FileUtils.touch("#{RAILS_ROOT}/app/factories/animal_factory.rb")
    end
    
    after(:all) do
      FileUtils.rm(File.dirname(__FILE__) + "/sample_objects/animal.rb")
      FileUtils.rm("#{RAILS_ROOT}/app/factories/animal_factory.rb")      
    end
    
    it "does not create a factory for the presenter" do
      FactoryLoader.load(File.dirname(__FILE__) + "/sample_objects")
      Object.const_defined?("AnimalFactory").should be_false
    end
  end

  describe "a created factory" do
    before(:all) do
      ::Person = stub("Person model")
      dir = File.dirname(__FILE__) + "/sample_objects"
      Dir["#{dir}/*.rb"].each{ |f| require f }
      FactoryLoader.load(dir)
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