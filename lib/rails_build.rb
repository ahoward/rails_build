require "rails_build/engine"

module RailsBuild
  require "fattr"

  Fattr(:application){ defined?(Rails.application) ? Rails.application : nil }

  def RailsBuild.configure(&block)
    block.call(configuration)
  end

  def RailsBuild.load_config!(path = nil)
    path ||= application.root.join('config/rails_build.rb').to_s

    if test(?s, path)
      Kernel.load(path)
    end
  end

  def RailsBuild.configuration
    @configuration ||= Configuration.new
  end

  def RailsBuild.config
    RailsBuild.configuration
  end

  class Configuration
    fattr(:urls){ [] }
    fattr(:trailing_slash){ true }

    def urls(*args, &block)
      @urls ||= []
      args.join(' ').scan(/[^\s]+/).each{|arg| @urls << arg}
      @urls.uniq!
      block ? @urls.each(&block) : @urls
    end
  end
end
