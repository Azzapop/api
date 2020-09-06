require "yaml"

module Api
  # Throws if config file doesn't exist
  CONFIG = File.open("config.yml") { |f| Configuration.from_yaml(f) }

  class Configuration
    include YAML::Serializable

    property port : Int32 = 8080
  end
end
