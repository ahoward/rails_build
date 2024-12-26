module RailsBuild
  VERSION = '2.4.5' unless defined?(VERSION)

  class << self
    def version
      VERSION
    end

    def repo
      'https://github.com/ahoward/rails_build'
    end

    def summary
      <<~____
        a small, simple, bullet proof, and fast enough static site generator built on top of the rails you already know and love
      ____
    end

    def description
      <<~____
        rails_build is a very small, fast enough, static site generator built
        on top of the rails you already know and love.

        it's been in production usage for close to a decade but i've been too
        busy to relase it until now.  also, #wtf is up with javascript land?!

        it has a small set of dependencies, namely the `parallel` gem, and
        requires absolutely minimal configuration.  it should be pretty darn
        self explanatory:
      ____
    end

    def libs
      %w[
        fileutils pathname thread socket timeout time uri etc securerandom logger json tempfile net/http
      ]
    end

    def dependencies
      {
        'parallel' =>
          ['parallel', '~> 1.26'],

        'getoptlong' =>
          ['getoptlong', '~> 0.2'],
      }
    end

    def libdir(*args, &block)
      @libdir ||= File.dirname(File.expand_path(__FILE__))
      args.empty? ? @libdir : File.join(@libdir, *args)
    ensure
      if block
        begin
          $LOAD_PATH.unshift(@libdir)
          block.call
        ensure
          $LOAD_PATH.shift
        end
      end
    end

    def load(*libs)
      libs = libs.join(' ').scan(/[^\s+]+/)
      libdir { libs.each { |lib| Kernel.load(lib) } }
    end

    def load_dependencies!
      libs.each do |lib|
        require lib
      end

      begin
        require 'rubygems'
      rescue LoadError
        nil
      end

      has_rubygems = defined?(gem)

      dependencies.each do |lib, dependency|
        gem(*dependency) if has_rubygems
        require(lib)
      end
    end
  end
end
