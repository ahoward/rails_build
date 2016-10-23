desc "execute the rails_build program with options, `rails build help=true` for more..."

task :rails_build do |task, options|
  engine_root = File.expand_path('../../..', __FILE__)
  engine_bin = File.join(engine_root, 'bin')
  bin = File.join(engine_bin, 'rails_build')

  args = ARGV.map{|arg| "#{ arg }"}
  task_name = args.shift

  argv = [bin]

  args.each do |arg|
    k, v = arg.split('=', 2).map{|s| s.strip}

    case v.downcase
      when 'true', ''
        argv << "--#{ k }"
      when 'false'
        nil
      else
        argv << "--#{ k }=#{ v }"
    end
  end

  command_line = argv.join(' ')

  exec(command_line)
end

task :build => :rails_build
