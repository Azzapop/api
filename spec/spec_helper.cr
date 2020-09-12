ENV["CRYSTAL_ENV"] = "test"

require "spectator"
# TODO change to require "../src/*"
require "../src/database"
require "../src/routes"
require "../src/models/*"
require "../src/util/*"

Spectator.configure do |config|
  config.profile
end

def capture_action(&block : Api::Routes::Action)
  block
end
