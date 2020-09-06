require "../../spec_helper"

Spectator.describe Api::Configuration do
  let(yaml) { %( port: 9999 ) }

  it "has a config" do
    expect(Api::CONFIG).to be_a(Api::Configuration)
  end

  it "parses values from yaml" do
    config = described_class.from_yaml(yaml)

    expect(config.port).to eq(9999)
  end
end
