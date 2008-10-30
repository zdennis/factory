require File.dirname(__FILE__) + '/spec_helper'

describe Factory do
  class Dummy
  end
  
  class DummyWithBlock
    attr_reader :block_result
    
    def initialize(*args, &blk)
      @block_result = blk.call
    end
  end
  
  class DummyFactory < Factory
  end
  
  class DummyWithBlockFactory < Factory
  end
  
  describe 'creating a object from the factory' do
    it "creates and returns an object based on the name of the factory passing the arguments through" do
      Dummy.should_receive(:new).with(:foo => "bar").and_return "some dummy"
      DummyFactory.new.create(:foo => "bar").should == "some dummy"
    end
    
    it "creates and returns a Dummy passing the block through" do
      dummy = DummyWithBlockFactory.new.create { 6 }
      dummy.block_result.should == 6
    end
  end
  
  describe 'creating a collection of decorated objects' do
    context "when using a DummyFactory" do
      it "returns a collection of Dummy objects" do
        dummies = [Dummy.new, Dummy.new]
        Dummy.should_receive(:new).with(:dummy => dummies[0]).and_return "dummy 1"
        Dummy.should_receive(:new).with(:dummy => dummies[1]).and_return "dummy 2"
        collection = DummyFactory.new.create_collection dummies
        collection.should == [ "dummy 1", "dummy 2" ]
      end
      
      it "returns a collection of Dummy objects when told what convention to folow" do
        objects = [Object.new, Object.new]
        Dummy.should_receive(:new).with(:dummy => objects[0]).and_return "dummy 1"
        Dummy.should_receive(:new).with(:dummy => objects[1]).and_return "dummy 2"
        collection = DummyFactory.new.create_collection objects, :as => :dummy
        collection.should == [ "dummy 1", "dummy 2" ]        
      end
    end
    
    context "when using a DummyPresenterFactory" do
      class DummyPresenterFactory < Factory
      end
      class DummyPresenter
      end
    
      it "returns a collection of DummyPresenter objects" do
        dummies = [Dummy.new, Dummy.new]
        DummyPresenter.should_receive(:new).with(:dummy => dummies[0]).and_return "dummy 1"
        DummyPresenter.should_receive(:new).with(:dummy => dummies[1]).and_return "dummy 2"
        collection = DummyPresenterFactory.new.create_collection dummies
        collection.should == [ "dummy 1", "dummy 2" ]
      end      
    end
    
    context "when there is a CollectionMethods module defined" do
      class DummyFactory
        module CollectionMethods
          def speak
            "duh"
          end
        end
      end
      
      it "will include the module into the returned collection" do
        dummies = [Dummy.new]
        Dummy.stub!(:new).with(:dummy => dummies.first).and_return "dummy 1"
        collection = DummyFactory.new.create_collection dummies
        collection.speak.should == "duh"
      end
    end
  end
end