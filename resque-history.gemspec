# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "resque-history"
  s.version     = Resque::Plugins::Pause::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Wandenberg Peixoto"]
  s.email       = ["wandenberg@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A Resque plugin to add functionality to pause resque jobs through the web interface.}
  s.description = %q{A Resque plugin to add functionality to pause resque jobs through the web interface.

Using a `pause` allows you to stop the job for a slice of time.
The job finish the process it are doing and don't get a new task to do,
until the queue is released.
You can use this functionality to do some maintenance whithout kill workers, for example.}

  s.rubyforge_project = "resque-history"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.has_rdoc      = false

  s.add_dependency('resque', '>= 1.9.10')

  s.add_development_dependency('rspec', '>= 2.3.0')
  s.add_development_dependency('rack-test')
  s.add_development_dependency('simplecov', '>= 0.4.2')

end
