require "../router"

module Api
  module Folder
    extend Routes

    get("/folders") do |req, res, param|
      puts req.inspect
      res.content_type = "text/plain"
      res.print "folders"
    end

    get("/folder/:id") do |req, res, param|
      puts req.inspect
      res.content_type = "text/plain"
      res.print param["id"]
    end
  end
end
