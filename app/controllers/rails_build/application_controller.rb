module RailsBuild
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    def index
    end

    def configuration
      render :json => RailsBuild.configuration, :layout => false
    end
  end
end
