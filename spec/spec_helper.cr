require "../src/routes"
require "../src/util/singleton"
require "spectator"

# TODO mock server / configure in env
LOCAL_TEST_PORT = 8081

Spectator.configure do |config|
  config.profile
end

def capture_action(&block : Api::Routes::Action)
  block
end
