require 'fileutils'

spec_helper = File.dirname(__FILE__) + '/../../../../spec/spec_helper.rb'
if File.exists?(spec_helper)
  # "Running specs inside of rails project. Letting the Rails project load rspec."
  require spec_helper
else
  # "Running specs outside of rails project. Using active_support and rspec gems."
  require 'rubygems'
  require 'active_support'  
  require 'spec'
end

SAMPLE_PROJECT_DIR = File.dirname(__FILE__) + '/sample_project'
CUSTOM_FACTORIES_DIR = SAMPLE_PROJECT_DIR + "/lib/factories"
SAMPLE_LIB_DIR = SAMPLE_PROJECT_DIR + "/lib"
FileUtils.mkdir_p(CUSTOM_FACTORIES_DIR)
require File.dirname(__FILE__) + '/../lib/factory_loader'
require File.dirname(__FILE__) + '/../lib/factory'
