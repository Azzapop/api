require "http/server"
require "./routes"
require "./controllers/*"

module Api
  include Folder

  VERSION = "0.1.0"

  server = HTTP::Server.new([Routes::Router.new])

  address = server.bind_tcp 8080
  puts "Listening on http://#{address}"
  server.listen
end
