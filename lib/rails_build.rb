require "rails_build/engine"

module RailsBuild
  def RailsBuild.application
    defined?(Rails.application) ? Rails.application : nil
  end

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
    def trailing_slash(*args, &block)
      unless defined?(@trailing_slash)
        @trailing_slash = true
      end

      case args.size
        when 0
          @trailing_slash
        when 1
          @trailing_slash = !!args.first
        else
          raise ArguementError.new(args.map{|arg| arg.class.name}.join(', '))
      end
    end

    def trailing_slash=(value)
      trailing_slash(value)
    end

    def urls(*args, &block)
      unless defined?(@urls)
        @urls = []
      end

      if args.size > 0
        args.join(' ').scan(/[^\s]+/).each{|arg| @urls << arg}
        @urls.uniq!
      end

      block ? @urls.each(&block) : @urls
    end
  end
end
