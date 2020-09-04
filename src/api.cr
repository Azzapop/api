require "./version"
require "./controllers/*"

module Api
  include Folder

  server = HTTP::Server.new([Routes::Router.new])

  address = server.bind_tcp 8080
  puts "Listening on http://#{address}"
  server.listen
end
