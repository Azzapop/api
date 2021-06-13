require "mime"
require "../util/parameters"

class BaseController
  include Parameters

  property request : HTTP::Request
  property response : HTTP::Server::Response
  property params : Hash(String, String)
  property status : HTTP::Status = HTTP::Status::OK
  property content_type : String = MIME::DEFAULT_TYPES[".json"]

  def initialize(@request, @response, @params)
  end

  macro inherited
    macro method_added(method)
      \{% if method.visibility == :public %}

        def \{{ method.name }}_response
          \{% parent_dir =  __DIR__.split('/')[0..-2].join('/') %}
          \{% folder_structure = @type.name.downcase.gsub(/controller/, "").split("::").join("/") %}
          \{% view = method.name %}
          \{% path = "#{parent_dir.id}/views/#{folder_structure.id}/#{view.id}.json.cr" %}
          JSON.build(@response.output) do |json|
            \{{ read_file(path).id }}
          end
        end
      \{% end %}
    end
  end
end
