(in /Users/zdennis/source/opensource_projects/factory_loader)
Gem::Specification.new do |s|
  s.name = %q{factory}
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Zach Dennis"]
  s.date = %q{2008-10-15}
  s.description = %q{Factory is intended to help scale object creation with less pain and less refactoring.  Public git repository: 	git://github.com/zdennis/factory_loader.git}
  s.email = ["zach.dennis@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "factory.gemspec", "lib/factory.rb", "lib/factory/factory.rb", "lib/factory/loader.rb", "spec/factory_loader_spec.rb", "spec/factory_spec.rb", "spec/sample_project/lib/cat.rb", "spec/sample_project/lib/dog.rb", "spec/sample_project/lib/factories", "spec/sample_project/lib/factories/fish", "spec/sample_project/lib/factories/fish/dolphin_factory.rb", "spec/sample_project/lib/fish", "spec/sample_project/lib/fish/dolphin.rb", "spec/sample_project/lib/fish/guppy.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/zdennis/factory_loader/wikis (url)}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{factory}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Factory is intended to help scale object creation with less pain and less refactoring}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_development_dependency(%q<hoe>, [">= 1.7.0"])
    else
      s.add_dependency(%q<hoe>, [">= 1.7.0"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.7.0"])
  end
end
