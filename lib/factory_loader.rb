require 'find'

# FactoryLoader is intended to help scale object creation with less pain and less 
# refactoring. 
#
# In the early stages of a project object creation is simple and object
# dependencies are kept to a minimum. As the project grows so does the
# complexity of object dependencies and object creation. It doesn't make
# sense to create custom factory classes upfront to deal with complex
# object construction that may not exist yet. But when those custom
# factories are needed it is usually painful and time consuming to update
# the code base to use them. It's also easy for developers to give-in
# due to time constraints and start making bad decisions.
#
# This is where FactoryLoader comes into play. It automaticaly creates a Factory
# class for your objects and provides a Factory#create method which passes any arguments
# along to your object's constructor.
#
# When you need to have custom factory behavior you can implement the factory
# without having to update other code references (assuming you've used them
# in the rest of your application rather then direct class references).
#
# For example given a directory structure like the below:
#
#   init.rb
#   lib/
#    |--things/
#           |-- foo.rb
#           |-- bar.rb
#    |--factories/
#           |-- bar_factory.rb
#
# Given this project directory structure you could have the following code 
# in init.rb:
#    factory_loader = FactoryLoader.new("lib/factories")
#    factory_loader.load("lib/things")
# 
# The first call constructs a factory loader telling it which directory is used
# to store custom factories. 
#
# The second call will create a factory for each *.rb file in the lib/things/
# directory. So for the foo.rb file a FooFactory class will be created
# which can be used to wrap creation of Foo objects. The generated factory
# will provide a #create method which will pass along all arguments to
# the constructor of the object it wraps. So...
#    FooFactory.new.create :a => :b 
# is the same as:
#    Foo.new :a => :b
#
# A FooFactory will be created, but a BarFactory will not. This is because
# we told the FactoryLoader that custom factories are storied in lib/factories/
# and a bar_factory.rb exists there, so FactoryLoader assumes you want to use
# a custom factory.
#
# Author: Zach Dennis, zdennis at mutuallyhuman dot com
class FactoryLoader
  VERSION = "0.1.0"
  
  def initialize(*factory_paths)
    @factory_paths = factory_paths.map{ |f| File.expand_path(f) } 
  end

  def load(directory) # :nodoc:
    Dir[directory + "/**/*.rb"].each do |file|
      object_filename = File.basename(file, ".rb")
      factory_filepath = "#{object_filename}_factory.rb"
      unless custom_factory_exists?(factory_filepath)
        load_object_factory object_filename.classify
      end
    end  
  end
  
  private
  
  def custom_factory_exists?(factory_filepath)
    found = false
    @factory_paths.find do |path|
      found = Dir["#{path}/**/#{factory_filepath}"].any?
    end
    found
  end
  
  def load_object_factory(object_name)
    factory_name = "#{object_name}Factory"
    unless Object.const_defined?(factory_name)
      eval <<-CODE
        class ::#{factory_name}
          def create(options={})
            #{object_name}.new options
          end
        end
      CODE
    end
  end
end


