require "../../spec_helper"

Spectator.describe Capture do
  describe "#block" do
    alias Get1 = -> Int32
    @blokk = Capture(Get1).block { next 1 }

    it "captures and returns a block" do
      expect(@blokk.call()).to eq(1)
    end

    it "has the correct type" do
      expect(@blokk).to be_a(Get1)
    end
  end
end
