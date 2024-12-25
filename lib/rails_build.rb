require_relative 'rails_build/_lib.rb'

RailsBuild.load_dependencies!

module RailsBuild
  def RailsBuild.configure(&block)
    @configure = block
  end

  def RailsBuild.dump_config!(path: config_path, dump: config_dump_path)
    config = RailsBuild.load_config!(path:)

    json = JSON.pretty_generate(config.as_json)

    dirname = File.dirname(dump)
    FileUtils.mkdir_p(dirname)
    IO.binwrite(dump, json)

    dump
  end

  def RailsBuild.load_config!(path: config_path)
    Kernel.load(path)

    if @configure
      @configure.call(RailsBuild.configuration)
    end

    RailsBuild.configuration
  end

  def RailsBuild.config_path
    case
      when ENV['RAILS_BUILD_CONFIG']
        ENV['RAILS_BUILD_CONFIG']
      when defined?(Rails)
        Rails.application.root.join('config/rails_build.rb')
      else
        './config/rails_build.rb'
    end.to_s
  end

  def RailsBuild.config_dump_path
    case
      when ENV['RAILS_BUILD_CONFIG_DUMP']
        ENV['RAILS_BUILD_CONFIG_DUMP']
      when defined?(Rails)
        Rails.application.root.join('tmp/rails_build.json')
      else
        './tmp/rails_build.json'
    end.to_s
  end

  def RailsBuild.configuration
    @configuration ||= Configuration.new
  end

  def RailsBuild.config
    RailsBuild.configuration
  end

  class Configuration < Hash
    ATTRS = %w[
      path
      trailing_slash
      force_ssl
      urls
      index_html
    ]

    def Configuration.defaults
      defaults = {
        path: RailsBuild.config_path,
        trailing_slash: (defined?(Rails) ? !!Rails.application.default_url_options[:trailing_slash] : false),
        force_ssl: (defined?(Rails) ? !!Rails.configuration.force_ssl : false),
        urls: %w[ / ],
        index_html: true,
      }
    end

    def Configuration.stringify_keys!(hash)
      hash.transform_keys!(&:to_s)

      hash.each do |key, val|
        if val.is_a?(Hash)
          Configuration.stringify_keys!(val)
        end
      end

      hash
    end

    def initialize(hash = {})
      if hash.empty?
        hash = Configuration.defaults
      end

      hash.each{|attr, value| send("#{ attr }=", value)}

      Configuration.stringify_keys!(self)
    end

    ATTRS.each do |attr|
      getter = "#{ attr }"
      setter = "#{ attr }="
      query = "#{ attr }?"

      define_method(getter) do |*args|
        case
          when args.size == 0
            fetch(attr)
          when args.size == 1
            value = args.first
            send(setter, value)
          else
            raise ArguementError.new(args.inspect)
        end
      end

      define_method(setter) do |value|
        update(attr => value)
      end

      define_method(query) do
        !!fetch(attr)
      end
    end

    def to_json(*args, **kws, &block)
      JSON.pretty_generate(self)
    end
  end

  class Assassin
    def Assassin.ate(*args, &block)
      new(*args, &block)
    end

    attr_accessor :parent_pid
    attr_accessor :child_pid
    attr_accessor :pid
    attr_accessor :path

    def initialize(child_pid, options = {})
      @child_pid = child_pid.to_s.to_i
      @parent_pid = Process.pid
      @options = Assassin.options_for(options)
      @pid, @path = Assassin.generate(@child_pid, @options)
    end

    def Assassin.options_for(options)
      options.inject({}){|h, kv| k,v = kv; h.update(k.to_s.to_sym => v)}
    end

    def Assassin.generate(child_pid, options = {})
      path = File.join(Dir.tmpdir, "assassin-#{ child_pid }-#{ SecureRandom.uuid }.rb")
      script = Assassin.script_for(child_pid, options)
      IO.binwrite(path, script)
      pid = Process.spawn "ruby #{ path }"
      [pid, path]
    end

    def Assassin.script_for(child_pid, options = {})
      parent_pid = Process.pid
      delay = (options[:delay] || 0.42).to_f

      script = <<-__
        Process.daemon

        require 'fileutils'
        at_exit{ FileUtils.rm_f(__FILE__) }

        parent_pid = #{ parent_pid }
        child_pid = #{ child_pid }
        delay = #{ delay }

        m = 24*60*60
        n = 42

        m.times do
          begin
            Process.kill(0, parent_pid)
          rescue Object => e
            sleep(delay)

            if e.is_a?(Errno::ESRCH)
              n.times do
                begin
                  Process.kill(15, child_pid) rescue nil
                  sleep(rand + rand)
                  Process.kill(9, child_pid) rescue nil
                  sleep(rand + rand)
                  Process.kill(0, child_pid)
                rescue Errno::ESRCH
                  break
                end
              end
            end

            exit
          end

          sleep(1)
        end
      __

      return script
    end
  end
end
