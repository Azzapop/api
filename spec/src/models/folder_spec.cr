require "../../spec_helper"

Spectator.describe Folder do
  before_all { Jennifer::Adapter.default_adapter.begin_transaction }
  after_all { Jennifer::Adapter.default_adapter.rollback_transaction }

  it "validates the name has less than 15 characters" do
    f2 = described_class.create(name: "a way too long name by far")
    expect(f2).to be_invalid
  end
end
