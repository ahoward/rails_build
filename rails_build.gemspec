## rails_build.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "rails_build"
  spec.version = "2.4.4"
  spec.required_ruby_version = '>= 3.0'
  spec.platform = Gem::Platform::RUBY
  spec.summary = "a small, simple, bullet proof, and fast enough static site generator built on top of the rails you already know and love"
  spec.description = "rails_build is a very small, fast enough, static site generator built\non top of the rails you already know and love.\n\nit's been in production usage for close to a decade but i've been too\nbusy to relase it until now.  also, #wtf is up with javascript land?!\n\nit has a small set of dependencies, namely the `parallel` gem, and\nrequires absolutely minimal configuration.  it should be pretty darn\nself explanatory:"
  spec.license = "Nonstandard"

  spec.files =
["LICENSE",
 "README.md",
 "Rakefile",
 "bin",
 "bin/rails_build",
 "lib",
 "lib/rails_build",
 "lib/rails_build.rb",
 "lib/rails_build/_lib.rb",
 "rails_build.gemspec"]

  spec.executables = ["rails_build"]
  
  spec.require_path = "lib"

  
    spec.add_dependency(*["parallel", "~> 1.26"])
  
    spec.add_dependency(*["getoptlong", "~> 0.2"])
  

  spec.extensions.push(*[])

  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "https://github.com/ahoward/rails_build"
end
