

app = Rails.application

app.configure do
  #app.config.force_ssl = false
  #app.config.hosts.clear
end

url = '/'

session = ActionDispatch::Integration::Session.new(app)

uuids = []
Dir.glob('public/ro/pages/*') do |path|
  uuid = File.basename(path)
  uuids << uuid
end

urls = []
uuids.each do |uuid|
  urls << "/md/#{ uuid }"
end


#uuid = '019400b0-1a56-7b12-bee4-2b607c906359'
#url = "/md/#{ uuid }"

FileUtils.mkdir_p('./md')

a = Time.now

slices = []

urls.each_slice(100) do |slice|
  slices << slice
end

Parallel.each(slices, in_proccess: 4) do |slice|
  #session = ActionDispatch::Integration::Session.new(app)

  Parallel.each(slice, in_threads: 4) do |url|
    Rails.logger.silence do
      status = session.get(url)
      body = session.response.body

      path = '.' + url + '.html'
      IO.binwrite(path, body)
      puts path
    end
  end
end


b = Time.now
puts((b - a).round(2))

