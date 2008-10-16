require 'find'

# FactoryLoader is intended to help scale object creation with less pain and less 
# refactoring. 
#
# In the early stages of a project object creation is simple and 
# dependencies are kept to a minimum. As the project grows so does the
# complexity of object creation and dependencies. It doesn't make
# sense to create custom factory classes upfront to deal with complex
# object construction that may not exist yet. But when those custom
# factories are needed it is usually painful and time consuming to update
# the code base to use them. 
#
# This is where FactoryLoader comes into play. It automatically creates a Factory
# class for your objects and provides a Factory#create method which passes any arguments
# along to your object's constructor.
#
# When you need to have custom factory behavior you can implement the factory
# without having to update other code references (assuming you've used the factory
# in the rest of your application rather than direct class references).
#
#   project/
#     init.rb
#     lib/
#      |--things/
#             |-- foo.rb
#             |-- bar.rb
#      |--factories/
#             |-- bar_factory.rb
#
# Given the above project directory structure you could have the following code 
# in init.rb:
#    factory_loader = FactoryLoader.new("lib/factories")
#    factory_loader.load("lib/things")
# 
# The first call constructs a factory loader telling it which directory is used
# to store developer-written custom factories. 
#
# The second call will create a in-memory factory class for each *.rb file 
# in the lib/things/ directory. For example, a FooFactory class will be created to
# correspond with the foo.rb file. The generated factory
# will provide a #create method which will pass along all arguments to
# the constructor of the object it wraps. So...
#    FooFactory.new.create :a => :b 
# is the same as:
#    Foo.new :a => :b
#
# Given the same directory and file structure a BarFactory will NOT be created. This is because
# we told the FactoryLoader when we constructed it that custom factories are storied in lib/factories/
# and a bar_factory.rb file exists there, so FactoryLoader assumes you want to use
# a custom factory. It also assumes that the class inside of bar_factory.rb is BarFactory.
#
# FactoryLoader dynamically creates the factory classes -- they are not written
# to disk. FactoryLoader also uses file naming conventions to determine
# what to do. For example: 
#    foo.rb => FooFactory
#    crazy_dolphins.rb => CrazyDolphinsFactory
#
# === Factory.new
# The dynamically created factories are CLASSES and create is an INSTANCE method on them. You
# have to construct a factory in order to use it. This is so the factories themselves can be easily used in dependency injection
# frameworks. 
#
# === Public Git repository: 
# git://github.com/zdennis/factory_loader.git
# 
# === Homepage: 
# http://github.com/zdennis/factory_loader/wikis
#
# === Author: 
# * Zach Dennis at Mutually Human Software (zach.dennis@gmail.com, zdennis@mutuallyhuman.com)
#
# === Special Thanks
# * Brandon Keepers at CollectiveIdea
# * Dave Crosby at Atomic Object
# * Ryan Fogle at Atomic Object
class FactoryLoader
  
  # Constructs a FactoryLoader. The passed in factory_paths are searched recursively.
  def initialize(*factory_paths)
    @factory_paths = factory_paths.map{ |f| File.expand_path(f) } 
  end

  # Creates factory classes based on searching filenames in the passed in directory
  # and comparing them against factory file names in the passed in factory_paths
  # given to the constructor.
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
        class ::#{factory_name} < Factory
        end
      CODE
    end
  end
end


