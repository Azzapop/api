require "jennifer"
require "jennifer/adapter/mysql"
require "./util/config"

module Api
  Jennifer::Config.read("config.yml", &.["database"][CRYSTAL_ENV])

  Jennifer::Config.configure do |config|
    config.logger = Log.for("db", :debug)
  end
end
