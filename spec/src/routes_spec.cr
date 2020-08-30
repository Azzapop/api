require "../spec_helper"

# These specs will fail to compile if the Routes module doesn't define the
# HTTP verbs as methods in the Api::Routes module
module Specs::HouseControllerExample
  extend Api::Routes

  get("/houses") { |req, res, params| res.print("get") }
  head("/houses") { |req, res, params| res.headers.add("head", "head") }
  post("/house") { |req, res, params| res.print("post") }
  put("/house/:id") { |req, res, params| res.print("put #{params["id"]}") }
  delete("/house/:id") { |req, res, params| res.print("delete #{params["id"]}") }
  connect("/houses") { |req, res, params| res.print("connect") }
  options("/houses/options") { |req, res, params| res.print("options") }
  trace("/houses") { |req, res, params| res.print("trace") }
  patch("/house/:id") { |req, res, params| res.print("patch #{params["id"]}") }
end

Spectator.describe Api::Routes::Router do
  describe "self.build_route" do
    it "upcases the method passes to it" do
      expect(described_class.build_route("get", "/house")).to eq("GET/house")
    end

    it "joins the method and the path with a / between them" do
      expect(described_class.build_route("get", "house")).to eq("GET/house")
    end

    it "strips unecessary '/' characters" do
      expect(described_class.build_route("get", "/house")).to eq("GET/house")
      expect(described_class.build_route("get", "///house")).to eq("GET/house")
      expect(described_class.build_route("get", "/house/")).to eq("GET/house")
      expect(described_class.build_route("get", "/house////")).to eq("GET/house")
    end
  end

  describe "self.add_route" do
    it "adds the route to the routes" do
      route = described_class.build_route("get", "/houses/patios")
      block = capture_action { |req, res, param| "get all patios" }
      described_class.add_route(route, block)

      result = described_class.find_route(route)
      expect(result).to be_found
      expect(result.payload).to eq(block)
    end
  end

  describe "self.find_route" do
    it "finds the route" do
      route = described_class.build_route("get", "/houses/:id/garage")
      block = capture_action { |req, res, params| "house #{params["id"]} garage" }
      described_class.add_route(route, block)

      result = described_class.find_route("GET/houses/1/garage")
      expect(result).to be_found
      expect(result.payload).to eq(block)
      expect(result.params).to eq({ "id" => "1" })
    end
  end

  context "inherits from HTTP::Handler" do
    server = HTTP::Server.new(described_class.new)
    before_all { spawn { server.listen(8080) } }
    after_all { server.close }
    let(client) { HTTP::Client.new("localhost", 8080) }

    it "handles a GET request" do
      response = client.get("/houses")
      expect(response.status).to be_ok
      expect(response.body).to eq("get")
    end

    it "hanles a HEAD request" do
      response = client.head("/houses")
      expect(response.status).to be_ok
      expect(response.headers["head"]).to eq("head")
    end

    it "handles a POST request" do
      response = client.post("/house")
      expect(response.status).to be_ok
      expect(response.body).to eq("post")
    end

    it "handles a PUT request" do
      response = client.put("/house/1")
      expect(response.status).to be_ok
      expect(response.body).to eq("put 1")
    end

    it "handles a DELETE request" do
      response = client.delete("/house/1")
      expect(response.status).to be_ok
      expect(response.body).to eq("delete 1")
    end

    it "handles a CONNECT request" do
      response = client.exec("connect", "/houses")
      expect(response.status).to be_ok
      expect(response.body).to eq("connect")
    end

    it "handles an OPTIONS request" do
      response = client.options("/houses/options")
      expect(response.status).to be_ok
      expect(response.body).to eq("options")
    end

    it "handles a TRACE request" do
      response = client.exec("trace", "/houses")
      expect(response.status).to be_ok
      expect(response.body).to eq("trace")
    end

    it "handles a PATCH request" do
      response = client.patch("/house/1")
      expect(response.status).to be_ok
      expect(response.body).to eq("patch 1")
    end

    it "fails at an unknown endpoint" do
      response = client.get("/sfghkjghkvbagk")
      expect(response.status).to be_not_found
    end
  end
end
