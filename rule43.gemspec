# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rule43/version"

Gem::Specification.new do |s|
  s.name        = "rule43"
  s.version     = Rule43::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Linking Paths"]
  s.email       = ["hello@linkingpaths.com"]
  s.homepage    = "https://github.com/mikz/norma43"
  s.summary     = %q{A parser for norma43 files, a standard from the spanish banking industry for account movements)}
  s.description = %q{A parser for norma43 files, a standard from the spanish banking industry for account movements)}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"

  s.required_ruby_version = '~> 2.0'
end
