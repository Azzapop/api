require "http/server/handler"

module Api
  module Routes
    HTTP_VERBS = %w(get head post put delete connect options trace patch)

    {% for verb in HTTP_VERBS %}
      def {{ verb.id }}(route : String, &block : Action)
        Router.add_route("/{{ verb.id.upcase }}#{route}", block)
      end
    {% end %}

    alias Action = (HTTP::Request, HTTP::Server::Response, Hash(String, String)) -> Nil

    class Router
      include HTTP::Handler

      alias Routes = Radix::Tree(Action)
      getter routes : Routes

      INSTANCE = new

      def self.instance
        INSTANCE
      end

      def self.add_route(route : String, action : Action)
        INSTANCE.routes.add(route, action)
      end

      def initialize
        @routes = Routes.new
      end

      def call(context)
        request = context.request
        response = context.response

        result = @routes.find("/#{request.method}#{request.path}")
        if result.found?
          result.payload.call(request, response, result.params)
        else
          context.response.status_code = 404
        end
      end
    end
  end
end
