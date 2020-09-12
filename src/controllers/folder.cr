require "../routes"
require "../models/folder"

module Api
  module FolderController
    extend Routes

    post("/folder") do |req, res, param|
      res.content_type = "text/plain"
      # TODO form parser to hash
      HTTP::FormData.parse(req) do |part|
        if part.name == "name"
          folder = Folder.create(name: part.body.gets_to_end)
          res.print "folder id: #{folder.id}"
          next
        end
      end
    end

    get("/folder/:id") do |req, res, param|
      folder = Folder.find(param["id"])
      res.content_type = "text/plain"
      res.print folder.inspect
    end
  end
end
