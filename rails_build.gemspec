$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_build/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_build"
  s.version     = RailsBuild::VERSION
  s.authors     = ["ahoward"]
  s.email       = ["ara.t.howard@gmail.com"]
  s.homepage    = "https://github.com/ahoward/rails_build"
  s.summary     = "a teeny engine that turns your rails 5 application into a lean, mean, static site building machine"
  s.description = s.summary
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,bin}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.executables = "rails_build"

  s.add_dependency "rails", "~> 5.0.0", ">= 5.0.0.1"

  #s.add_dependency "coerce", ">= 0.0.8"
  #s.add_dependency "fattr", ">= 2.3.0"
  #s.add_dependency "map", ">= 6.6.0"

  s.add_dependency "threadify", ">= 1.4.5"
  s.add_dependency "passenger", ">= 5.0.30"
  s.add_dependency "persistent_http", ">= 2.0.1"


  #s.add_development_dependency "sqlite3"
end
