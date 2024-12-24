# TL;DR;

- install

  ```sh

    echo 'gem "raild_build"' >> Gemfile

    bundle

  ```

- setup

  ```sh

    rails_build --init

  ```

- build

  ```sh

    rails_build

  ```

- deploy?

  the contents of ./build/ are good to deploy to *any* static web host
  including netlify, vercel, an s3 bucket, or simply your app's own ./public
  directory in order to 'pre-cache' a ton of pages

  ps. if you want to preview your local static ./build i *highly* recommend

    https://github.com/copiousfreetime/launchy


# ABOUT

  rails_build is a very small, fast enough, static site generator built on top
  of the rails you already know and love.

  it's been in production usage for close to a decade but i've been too busy
  to relase it until now.  also, #wtf is up with javascript land?!

  it has a small set of dependencies, namely the `parallel` gem, and requires
  absolutely minimal configuration.  it should be pretty darn self
  explanatory:

```ruby

  # file : ./config/rails_build.rb

  <<~________

    this file should to enumerate all the urls you'd like to build

    the contents of your ./public directory, and any assets, are automaticaly
    included

    therefore you need only declare which dynamic urls, that is to say, 'routes'

    you would like included in your build

    it is not loaded except during build time, and will not affect your normal
    rails app in any way

  ________


  RailsBuild.configure do |config|

    # most of the time you are going to want your route included, which will
    # translate into an ./index.html being output in the build
    #

    config.urls << '/'

    # include any/all additional routes youd' like built thusly
    #

    Post.each do |post|
      config.urls << "/posts/#{ post.id }"
    end

    # thats it! - now just run `rails_build` and you are GTG

  end

```

# MOTIVATION

why another static site builder?  why not hugo or, the
other-soon-to-be-released-blazing-fast-one-i-am-building-on Roda?

because:

- there are a lot of Rails apps
- nothing is as fast as static
- Rails has no facility to 'pre-render' routes on deployment

so, you can use this tool to leverage the code and the app you already have,
and/or to utilize the entire Rails ecosystem, it's docs and gems, to build
sophisticated sites without needing to learn yet another framework.

# HOW IT WORKS

as always, docs are worthless and Ruby is beautiful, so #RTFC ->

  https://github.com/ahoward/rails_build/blob/main/bin/rails_build


# LICENSE

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

# AI _boo_

Any and all usage, in any way, shape, or form, in prohibited by any AI
application, or LLM.  This includes indexing, knowing about, training on, or
existing inside a commercial LLM or training data set.  Iff (and *only* if)
your LLM is OSS, please contact me directly before including this source.
