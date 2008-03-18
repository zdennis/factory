# The FactoryLoader is intended to help scaling complex object creation
# with less pain, and less refactoring. 
#
# When a project starts all object creation is simple, but as the project grows
# so does the complexity of object dependencies and object creation. It
# doesn't make sense to create custom factory classes upfront
# and it usually isn't needed for all objects. But when it is needed
# it is usually painful and time consuming to update each direct class reference
# and it is easy for developers to give-in and make bad design decisions.
# 
# That is where the FactoryLoader comes into play. It creates a Factory
# class for your objects and provides a #create method which passes any arguments
# along.
#
# When you need to have custom factory behavior you can implement the factory
# without having to update other code references (assuming you've used them
# in the rest of your application rather then direct class references).
#
# See FactoryLoader.load for more information.
#
# Author: Zach Dennis, zdennis at mutuallyhuman dot com
class FactoryLoader

  # Scans the passed in directory of objects and builds Factory wrapper
  # classes for them. For example the below directory structure:
  #
  #   lib/
  #    |--things/
  #           |-- foo.rb
  #           |-- bar.rb
  #    |--factories/
  #           |-- factory_loader.rb
  #           |-- bar_factory.rb
  #
  # FactoryLoader.load("lib/things") will create
  # a FooFactory class which wraps the creation
  # of a Foo object. FooFactory provides a #create method which will
  # pass along all arguments to a Foo.new call.
  #
  # Since a bar_object_factory.rb file exists within the same directory as
  # the FactoryLoader
  # will not create a BarPresenterFactory.
  # 
  
  def self.load(directory)
    new.load(directory)
  end

  def load(directory) # :nodoc:
    Dir[directory + "/*.rb"].each do |file|
      object_filename = File.basename(file, ".rb")
      factory_filepath = RAILS_ROOT + "/app/factories/#{object_filename}_factory.rb"
      unless File.exists?(factory_filepath)
        load_object_factory object_filename.classify
      end
    end  
  end
  
  private
  
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


