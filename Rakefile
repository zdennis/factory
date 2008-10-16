require 'rake/rdoctask'

task :default => :spec

task :spec do
  system "spec spec --pattern '**/*_spec.rb'"
end

desc "Generate RDoc documentation"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = "FactoryLoader: intended to help scaling complex object creation with less pain and less refactoring." 
  rdoc.rdoc_files.include('lib/**/*.rb', 'README.txt','History.txt','MIT-LICENSE')
end

require 'rubygems'
require 'hoe'
require './lib/factory/version'

Hoe.new('factory', Factory::VERSION) do |p|
  p.developer('Zach Dennis', 'zach.dennis@gmail.com')
end

namespace :rdoc do
  desc 'Generate and deploy documentation to rubyforge.'
  task :deploy do
    require 'fileutils'
    require 'yaml'
    Rake::Task[:rdoc].invoke
   
    dir = "factory"
    tempdir = "/tmp/#{dir}_rdoc"
    rdocdir = tempdir + "/#{dir}"
    FileUtils.mkdir_p rdocdir
    FileUtils.mv "rdoc", rdocdir

    system "rsync -avz --delete #{rdocdir} rubyforge.org:/var/www/gforge-projects/mhs/"
  end
end
