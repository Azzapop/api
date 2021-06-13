require "./version"
require "./controllers/*"
require "./database"
require "./routes"
require "./util/config"

module Api
  include Routes

  get("folders", FolderController, :index)
  get("folder/:id", FolderController, :show)
  post("folder", FolderController, :create)

  server = HTTP::Server.new([Routes::Router.new])
  address = server.bind_tcp(CONFIG.port)
  puts "Listening on http://#{address}"
  server.listen
end
