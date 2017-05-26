# RailsBuild

A very small, very simple, very fast, and bullet proof static site generator
built as a Rails 5 engine.



## How It Works

RailsBuild bundles all your assets, public directory, and configured urls into
a static site suitable for deployment to [Netlify](https://www.netlify.com/), Amazon S3, or your favorite
static website hosting solution.  It does this by:

- Booting your application in *production* mode
- Precompiling all assets
- Including every static resource in ./public/
- GET'ing every configured url via super fast parallel downloading

RailsBuild let's you leverage the entire Rails' ecosystem for your static
sites and requires learning practically no new techniques to make super fast
building static websites.



## Configuration

Configuration is quite simple, typically it will be much less than comparable
static site generators.  You need to drop a *./config/rails_build.rb* looking
something like this into your app:

```ruby

  RailsBuild.configure do |rails_build|

    urls = rails_build.urls

    urls << "/"

    urls << "/about/"

    urls << "/contact/"

 
    Post.each do |post|
      urls << blog_path(post) 
    end

  end


```

That's it: simply enumerate the urls - anything additional to your assets and
./public/ directory - that you want to include in your build.

## On Trailing Slashes

Most static hosting solutions support Apache style directory indexing and will be
better behaved with urls that look like

```markdown

  http://my.site.com/blog/

```

vs.

```markdown

  http://my.site.com/blog

```

RailsBuild tries to help you do this with a little bit of Rails' config that
is turned on by default but which can be turned off via

```ruby

  RailsBuild.configure do |rails_build|

    rails_build.trailing_slash false  # the default is 'true'

  end

```

The only real impact will be felt if you are using relative urls in your site
like './about' vs. '../about'



## Optimization and Notes

RailsBuild is fast.  Very fast.  [DOJO4](http://dojo4.com) has seen optimized [Middleman](https://middlemanapp.com/) builds of > 30 minutes dropped to *60 seconds* by simply making basic use of Rails' built-in caching facilites.

You app has to run in production mode to build!  Don't forget to setup
secrets, or anything else generally required in production mode.

When trying to squeeze out performance just remember that RailsBuild runs in
production mode and, therefore, making a build go fast follows the *exact same
rules* as making anything other Rails' application fast.  The first place to
reach is typically fragment caching of partials used in your app.


Finally, don't forget about *./config/initializers/assets.rb* - RailsBuild
doesn't do anything special to the asset pipeline and only those assets
normally built when

```bash

  ~> rake assets:precompile

```

is run will be included in the build.



## Installation

Add this line to your application's Gemfile:

```ruby

  gem 'rails_build'


```

And then execute:

```bash

$ bundle

$ bundle binstubs rails_build


```



## Building Your Site


After installation and configuration simply run

```bash

  ~> ./bin/rails_build


# or, if you prefer, simply

  ~> rails build


```



## Netlify

We love [Netlify](https://www.netlify.com/) at [DOJO4](http://dojo4.com).  RailsBuild works with netlify
out of the box and simply requires

```yaml

  build_command : ./bin/rails_build

  build_directory: build

```

to be configured as the build command and directory respectively.



## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
