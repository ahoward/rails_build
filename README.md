SELF
----

  https://github.com/ahoward/rails_build

TL;DR;
------

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


ABOUT
-----

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

      # most of the time you are going to want your root route included, which
      # will translate into an ./index.html being output in the build, as you
      # would expect.
      #

      config.urls << '/'

      # include any/all additional routes youd' like built thusly
      #

      Post.each do |post|
        config.urls << "/posts/#{ post.id }"
      end

      # thats it! - now just run `rails_build` and you are gtg

    end

  ```

CONFIGURATION
-------------

  although `rails_build` aims to be as zero-config as possible, it does expose
  a few configuration settings, which you may configure in
  `config/rails_build.rb`:

    - *config.urls*

      as shown above, the config has a list of urls that the build process
      will GET.  this is a simple array and contains only '/' by default, the
      root route, such that the default unconfigured build would map '/' ->
      'index.html' and not be empty.  if your app does not have a root route,
      or you do not wish to include that route in your build, simply call
      `config.urls.clear`


  - *config.force_ssl*

    this one can be important.  when `rails_build` starts your rails app, it
    does so with *RAILS_ENV=production*, such that the build is of production
    quality and speed.  (you can change this by running `rails_build
    --env=development`, etc.).  this can cause issues since the build runs on
    localhost, and rails (without `thruster`), has no facility for ssl
    termination.  as such, you may want the the following

    ```ruby
      # file : ./config/environments/production.rb

      config.force_ssl = ENV['RAILS_BUILD'] ? false : true
    ```

  - *config.index_html*

    controls the mapping of urls to build files, eg.

    ```ruby
      RailsBuild.configure do
        config.index_html = true # the default
        config.urls << "/post/42" #=> ./build/posts/42/index.html
      end

      # vs.

      RailsBuild.configure do
        config.index_html = false
        config.urls << "/post/42" #=> ./build/posts/42.html
      end
    ```

  - *config.path*

    this is the path to the build config file itself, the default is
    `./config/rails_build.rb`, as you would expect

  - *config.trailing_slash*

    this is current un-used, but maybe be used in the future.  it's default is the
    value of

    ```ruby
      Rails.application.default_url_options[:trailing_slash]
    ```

MOTIVATION
----------

  why yet _another_ static site builder?  why not hugo or, the
  other-soon-to-be-released-blazing-fast-one-i-am-building-on Roda?

  because:

    - there are a lot of Rails apps
    - nothing is as fast as static
    - Rails has no facility to 'pre-render' routes on deployment

  so, you can use this tool to leverage the code and the app you already have,
  and/or to utilize the entire Rails ecosystem, it's docs and gems, to build
  sophisticated sites without needing to learn yet another framework.

SPEED
-----

  `rails_build` is as fast as your rails app.  optimizing the build means
  optimizing your app so, the internet abounds with advice here, and all the
  production stuff one might normally do, caching, etc, is applicable for
  cranking things up.  that being said, on a 'normal' laptop one should expect
  to crank through 1000 urls in 10s of seconds.  this is what is meant by,
  _"good enough"_.

ENV
---

  at build time, the following environment variables will be available to your
  app, such that i can _"know"_ that it is being built.  they should be self
  explanatory:

  ```ruby
      ENV['RAILS_BUILD'] # a uuid fo the build
      ENV['RAILS_BUILD_TIME'] # a timestamp when the build was run

  ```

RTFM
----

  as always, docs are worthless and ruby is beautiful, so #RTFC ->

    https://github.com/ahoward/rails_build/blob/main/bin/rails_build


NOAI
----
  the gem is released under a 'NOAI' license.

  any and all usage, in any way, shape, or form, in prohibited by any ai
  application, or llm.  this includes indexing, editor support, knowing about,
  training on, or existing inside a commercial llm or training data set.  iff
  (that is not a typo) your llm is oss, please contact me directly before
  including this source.

  any usage by openai, or google, is forbidden regardless.

  for all other purposes and usages, the license is the same as Ruby's.

  ... helping Ruby developers keep thier jobs since 1995.
