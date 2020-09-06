require "../src/routes"
require "../src/util/*"
require "spectator"

Spectator.configure do |config|
  config.profile
end

def capture_action(&block : Api::Routes::Action)
  block
end
