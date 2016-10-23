module RailsBuild
  class Engine < ::Rails::Engine

    isolate_namespace RailsBuild

		initializer "rails_build.routes" do |application|
    # see config/routes.rb
    #
      RailsBuild.application = application

    # load config/rails_build.rb iff present
		#
      RailsBuild.load_config!
      
    # enforce trailing slash on urls
    #
      if RailsBuild.config.trailing_slash?
        application.default_url_options[:trailing_slash] = true

        ActionController::Base.module_eval do
          before_action :enforce_trailing_slash

          def enforce_trailing_slash
            if request.get?
              format = request.fullpath.split('.', 2)[1]

              if format.nil? and %w[ */* text/html ].include?(request.format.to_s)
                url = request.original_url
                url, query_string = url.split('?')

                unless url.ends_with?('/')
                  flash.keep

                  url = url + '/'

                  if query_string
                    url = url + '?' + query_string
                  end

                  redirect_to(url, :status => 302)
                end
              end
            end
          end
        end
      end
		end

  end
end
