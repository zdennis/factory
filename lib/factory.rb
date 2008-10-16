# Factory is a base class used fo creating object factories. It is
# used by FactoryLoader, but it can also be used as a base for
# custom factories. For example:
#
#    class FooFactory < Factory
#    end
#
# Factory can create a single instance of a target class, or it
# can create a collection of instances -- and extend them.
#
# == Factory#create
# Using the class name (minus the Factory part) this will construct an object passing in
# any arguments to that class's constructor. For example:
#    FooFactory.new.create :bar => "baz"
# is the same as:
#    Foo.new :bar => "baz"
#
# == Factory#create_collection
# Given a collection of objects, this will return an array of objects
# constructed using Factory#create. For example:
#    items = [ Foo.new, Foo.new, Bar.new ]
#    FooFactory.new.create_collection items
# will make the following calls:
#    create :foo => items.first   # => foo1
#    create :foo => items.second  # => foo2
#    create :bar => items.third   # => bar1
# and then it will return:
#    [ foo1, foo2, bar1 ]
#
# It works by looking at the class of the items being passed in. So if you 
# pass in an instance of Foo, it will turn that into the argument ":foo => instance_of_foo"
# and call the #create method.
#
# == Factory#create_collection CollectionMethods
# When using a custom factory, #create_collection will include any CollectionMethods
# module it finds on that custom factory into the returned array. For example:
#     class LineItemsFactory < Factory
#       module CollectionMethods
#         def total
#          inject(0){ |sum, item| sum + item.amount }
#         end
#       end
#     end
#
#     items = [ Item.new(:amount => 1), Item.new(:amount => 2)
#     line_items = LineItemsFactory.create_collections items
#     line_items.total # => 3
class Factory
  def create(*args, &blk)
    type = self.class.name.sub(/Factory$/, '').constantize
    type.new *args, &blk
  end
  
  def create_collection(objects)
    type = self.class.name.sub(/Factory$/, '').constantize
    returning objects.map {|o| type.new(o.class.name.underscore.to_sym => o) } do |collection|
      collection.extend self.class.const_get(:CollectionMethods) if self.class.const_defined?(:CollectionMethods)
    end
  end
end