# frozen_string_literal: true

require "webrick"

root = File.expand_path(ARGV.fetch(0))
port = Integer(ARGV.fetch(1, "4173"))
not_found = File.binread(File.join(root, "404.html"))

server = WEBrick::HTTPServer.new(
  Port: port,
  BindAddress: "127.0.0.1",
  DocumentRoot: root,
  AccessLog: [],
  Logger: WEBrick::Log.new($stderr, WEBrick::Log::WARN)
)

server.mount_proc("/") do |request, response|
  path = WEBrick::HTTPUtils.unescape(request.path)
  candidate = File.join(root, path)
  candidate = File.join(candidate, "index.html") if File.directory?(candidate)

  if File.file?(candidate) && candidate.start_with?(root + File::SEPARATOR)
    response.status = 200
    response.body = File.binread(candidate)
    response["Content-Type"] = WEBrick::HTTPUtils.mime_type(candidate, WEBrick::HTTPUtils::DefaultMimeTypes)
  else
    response.status = 404
    response["Content-Type"] = "text/html; charset=utf-8"
    response.body = not_found
  end
end

trap("TERM") { server.shutdown }
trap("INT") { server.shutdown }
server.start
