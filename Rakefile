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

namespace :gem do
  task :build do
    system "gem build factory_loader.gemspec"
  end
  
  task :install => "gem:build" do
    system "gem install factory_loader*.gem"
  end
  
  task :uninstall do
    system "gem uninstall factory_loader"
  end
end

namespace :rubyforge do
  task :deploy do 
    puts [
      "gem build factory_loader.gemspec",
      "rubyforge login",
      "rubyforge config mhs",
      "rubyforge create_package mhs factory_loader",
      "rubyforge add_release mhs factory_loader 0.x.0 factory_loader-0.x.0.gem"      
    ]
  end
end

require 'rubygems'
require 'hoe'
require './lib/factory_loader.rb'

Hoe.new('factory_loader', FactoryLoader::VERSION) do |p|
  p.developer('Zach Dennis', 'zach.dennis@gmail.com')
end
