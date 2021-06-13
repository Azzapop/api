require "../spec_helper"

Spectator.describe Api::Routes::Router do

  def eq_json(val)
    eq(JSON.build { |json| json.string val.to_s() } )
  end

  describe "self.build_route" do
    it "starts the route with a /" do
      expect(described_class.build_route("get", "/house")).to eq("/GET/house")
    end

    it "upcases the method passed to it" do
      expect(described_class.build_route("get", "/house")).to eq("/GET/house")
    end

    it "joins the method and the path with a / between them" do
      expect(described_class.build_route("get", "house")).to eq("/GET/house")
    end

    it "strips unecessary '/' characters" do
      expect(described_class.build_route("get", "/house")).to eq("/GET/house")
      expect(described_class.build_route("get", "///house")).to eq("/GET/house")
      expect(described_class.build_route("get", "/house/")).to eq("/GET/house")
      expect(described_class.build_route("get", "/house////")).to eq("/GET/house")
    end
  end

  describe "self.add_route" do
    it "adds the route to the routes" do
      route = described_class.build_route("get", "/houses/patios")
      block = capture_action { |req, res, param| res.print("get all patios") }
      described_class.add_route(route, block)

      result = described_class.find_route(route)
      expect(result).to be_found
      expect(result.payload).to eq(block)
    end
  end

  describe "self.find_route" do
    it "finds the route" do
      route = described_class.build_route("get", "/houses/:id/garage")
      block = capture_action { |req, res, params| res.print("house #{params["id"]} garage") }
      described_class.add_route(route, block)

      result = described_class.find_route("/GET/houses/1/garage")
      expect(result).to be_found
      expect(result.payload).to eq(block)
      expect(result.params).to eq({ "id" => "1" })
    end
  end

  context "inherits from HTTP::Handler" do
    let(handler) { described_class.new }

    # Build a response that would be received from the client to avoid creating and calling a server
    def client_response(method, route)
      io = IO::Memory.new
      request = HTTP::Request.new(method, route)
      response = HTTP::Server::Response.new(io)
      context = HTTP::Server::Context.new(request, response)

      # This spec context is testing that the Router handles the server context correctly in the
      # call method and checks the expected responses
      handler.call(context)

      response.close
      io.rewind
      HTTP::Client::Response.from_io(io)
    end

    it "handles a GET request" do
      response = client_response("GET", "/houses")
      expect(response.status).to be_ok
      expect(response.body).to eq_json("get")
    end

    it "handles a HEAD request" do
      response = client_response("HEAD", "/houses")
      expect(response.status).to be_ok
      expect(response.headers["head"]).to eq("head")
    end

    it "handles a POST request" do
      response = client_response("POST", "/house")
      expect(response.status).to be_ok
      expect(response.body).to eq_json("post")
    end

    it "handles a PUT request" do
      response = client_response("PUT", "/house/1")
      expect(response.status).to be_ok
      expect(response.body).to eq_json("put 1")
    end

    it "handles a DELETE request" do
      response = client_response("DELETE", "/house/1")
      expect(response.status).to be_ok
      expect(response.body).to eq_json("delete 1")
    end

    it "handles a CONNECT request" do
      response = client_response("CONNECT", "/houses")
      expect(response.status).to be_ok
      expect(response.body).to eq_json("connect")
    end

    it "handles an OPTIONS request" do
      response = client_response("OPTIONS", "/houses/options")
      expect(response.status).to be_ok
      expect(response.body).to eq_json("options")
    end

    it "handles a TRACE request" do
      response = client_response("TRACE", "/houses")
      expect(response.status).to be_ok
      expect(response.body).to eq_json("trace")
    end

    it "handles a PATCH request" do
      response = client_response("PATCH", "/house/1")
      expect(response.status).to be_ok
      expect(response.body).to eq_json("patch 1")
    end

    it "fails at an unknown endpoint" do
      response = client_response("GET", "/sfghkjghkvbagk")
      expect(response.status).to be_not_found
    end
  end
end
