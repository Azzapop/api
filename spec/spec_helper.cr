require "../src/routes"
require "../src/util/singleton"
require "spectator"

def capture_action(&block : Api::Routes::Action)
  block
end
