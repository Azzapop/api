require "../../spec_helper"

Spectator.describe Parameters do
  Parameters.permit_json_params(TestParams, { x: String, y: Int8 })

  describe "TestParams" do
    let(:json) { %({ "x": "val", "y": 3, "z": true }) }
    subject { TestParams.parse(json) }

    it "should only allow the given params" do
      expect(subject).to eq({ :x => "val", :y => 3 })
    end

    it "parses them in the correct types" do
      expect(subject[:x]).to be_a(String)
      expect(subject[:y]).to be_a(Int8)
    end

    it "does not include params that are not specified" do
      expect(subject[:z]).to be_nil
    end

    it "throws if the required values aren't present" do
      expect_raises(JSON::ParseException) { TestParams.parse(%({})) }
    end

    it "throws if the required values are the wrong type" do
      expect_raises(JSON::ParseException) { TestParams.parse(%({ "x": null, "y": 3 })) }
      expect_raises(JSON::ParseException) { TestParams.parse(%({ "x": "val", "y": "3" })) }
    end

    it "parses an IO" do
      io = IO::Memory.new(json)
      expect(TestParams.parse(io)).to eq({ :x => "val", :y => 3 })
    end

    def mutate(p : TestParams)
      p.x = "new val"
    end

    it "does not have mutable values" do
      params = TestParams.from_json(json)
      mutate(params)
      expect(params.x).to eq("val")
    end
  end
end

