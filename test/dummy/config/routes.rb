Rails.application.routes.draw do
  mount RailsBuild::Engine => "/rails_build"
end
