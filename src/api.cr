require "./version"
require "./controllers/*"
require "./util/config"

module Api
  include Folder

  server = HTTP::Server.new([Routes::Router.new])

  address = server.bind_tcp(CONFIG.port)
  puts "Listening on http://#{address}"
  server.listen
end
