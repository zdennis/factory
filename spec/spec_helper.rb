require 'fileutils'

spec_helper = File.dirname(__FILE__) + '/../../../../spec/spec_helper.rb'
if File.exists?(spec_helper)
  puts "Running specs inside of rails project. Letting the Rails project load rspec."
  require spec_helper
else
  puts "Running specs outside of rails project. Using active_support and rspec gems."
  require 'rubygems'
  require 'active_support'  
  require 'spec'
end

RAILS_ROOT = File.dirname(__FILE__) + '/rails_root'
FileUtils.mkdir_p(RAILS_ROOT + "/app/factories")
require File.dirname(__FILE__) + '/../lib/factory_loader'

# cleanup our dummy rails_root
at_exit do
  FileUtils.rm_rf(RAILS_ROOT + "/app/factories")
end
