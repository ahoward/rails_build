<<~________

  this file should to enumerate all the urls you'd like to build

  the contents of your ./public directory, and any assets, are automaticaly included

  therefore you need only declare which dynamic urls, that is to say, 'routes'

  you would like included in your build

  it is not loaded except during build time, and will not affect your normal rails app in any way

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