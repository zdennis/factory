require 'rake/rdoctask'

task :default => :spec

task :spec do
  system "spec spec --pattern '**/*_spec.rb'"
end

desc "Generate RDoc documentation"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = "FactoryLoader: intended to help scaling complex object creation with less pain and less refactoring." 
  rdoc.rdoc_files.include('lib/**/*.rb', 'README','CHANGES','MIT-LICENSE')
end

require 'rubygems'
require 'hoe'
require './lib/factory_loader.rb'

Hoe.new('factory_loader', FactoryLoader::VERSION) do |p|
  p.developer('Zach Dennis', 'zach.dennis@gmail.com')
end
