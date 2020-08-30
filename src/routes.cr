require "http/server/handler"
require "radix"
require "./util/singleton"

module Api
  module Routes
    alias Action = (HTTP::Request, HTTP::Server::Response, Hash(String, String)) -> Nil
    alias Routes = Radix::Tree(Action)
    alias RouteResult = Radix::Result(Action)

    HTTP_VERBS = %w(get head post put delete connect options trace patch)

    {% for verb in HTTP_VERBS %}
      def {{ verb.id }}(path : String, &block : Action) : Nil
        route = Router.build_route({{ verb }}, path)
        Router.add_route(route, block)
      end
    {% end %}

    class Router
      include HTTP::Handler

      private ROUTES = Routes.new

      def self.build_route(method : String, path : String) : String
        File.join([method.upcase].concat(path.split('/').reject!("")))
      end

      def self.add_route(route : String, action : Action) : Nil
        ROUTES.add(route, action)
      end

      def self.find_route(route : String) : RouteResult
        ROUTES.find(route)
      end

      def call(context : HTTP::Server::Context) : Nil
        request = context.request
        response = context.response

        route = Router.build_route(request.method, request.path)
        result = Router.find_route(route)
        if result.found?
          result.payload.call(request, response, result.params)
        else
          response.status_code = 404
        end
      end
    end
  end
end
