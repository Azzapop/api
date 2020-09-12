require "../../spec_helper"

Spectator.describe Api::Configuration do
  let(yaml) do
    %(
      port: 9999
      database:
        default: &default
          host: localhost
          user: username
          password: password
          adapter: mysql

        development:
          <<: *default
          db: development_db

        test:
          <<: *default
          db: test_db

        production:
          <<: *default
          db: production_db
    )
  end

  it "has a config" do
    expect(Api::CONFIG).to be_a(Api::Configuration)
  end

  it "parses values from yaml" do
    config = described_class.from_yaml(yaml)

    expect(config.port).to eq(9999)
    expect(config.database.development.host).to eq("localhost")
    expect(config.database.development.user).to eq("username")
    expect(config.database.development.password).to eq("password")
    expect(config.database.development.adapter).to eq("mysql")
    expect(config.database.development.db).to eq("development_db")
    expect(config.database.test.host).to eq("localhost")
    expect(config.database.test.user).to eq("username")
    expect(config.database.test.password).to eq("password")
    expect(config.database.test.adapter).to eq("mysql")
    expect(config.database.test.db).to eq("test_db")
    expect(config.database.production.host).to eq("localhost")
    expect(config.database.production.user).to eq("username")
    expect(config.database.production.password).to eq("password")
    expect(config.database.production.adapter).to eq("mysql")
    expect(config.database.production.db).to eq("production_db")
  end
end
