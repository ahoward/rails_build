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
  s.summary     = "a teeny engine that turns your rails application into a lean, mean, static site building machine"
  s.description = s.summary + ' '
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,bin}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.executables = "rails_build"

  s.add_dependency "rails", "~> 6", ">= 6"

  s.add_dependency "parallel", "~> 1.2", ">= 1.20.1"
  s.add_dependency "persistent_http", "~> 2.0", ">= 2.0.3"
end
