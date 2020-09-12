require "yaml"

module Api
  CRYSTAL_ENV = ENV["CRYSTAL_ENV"]? || "development"
  # Throws if config file doesn't exist
  CONFIG = File.open("config.yml") { |f| Configuration.from_yaml(f) }

  class Configuration
    include YAML::Serializable

    property port : Int32 = 8080
    property database : DatabaseConfig
  end

  class DatabaseConfig
    include YAML::Serializable

    property development : DbConfigSchema
    property test : DbConfigSchema
    property production : DbConfigSchema
  end

  class DbConfigSchema
    include YAML::Serializable

    property host : String
    property user : String
    property password : String
    property adapter : String
    property db : String
  end
end
