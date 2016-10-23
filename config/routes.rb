RailsBuild::Engine.routes.draw do
  get '/' => 'application#index'
  get '/configuration' => 'application#configuration'
end

if RailsBuild.application
  RailsBuild.application.routes.draw do
    mount RailsBuild::Engine => '/rails_build'
  end
end
