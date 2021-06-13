require "../../spec_helper"

Spectator.describe BaseController do
  let(:io) { IO::Memory.new }
  let(:request) { HTTP::Request.new("GET", "public_method") }
  let(:response) { HTTP::Server::Response.new(io) }
  let(:params) { { "test" => "data" } }

  it "instantiates properly" do
    instance = described_class.new(request, response, params)
    expect(instance.request).to eq(request)
    expect(instance.response).to eq(response)
    expect(instance.params).to eq(params)
    expect(instance.status).to eq(HTTP::Status::OK)
    expect(instance.content_type).to eq("application/json")
  end

  describe "when inherited" do
    subject { ExampleController.new(request, response, params) }

    it "creates xxxxx_response methods for public methods" do
      expect(subject).to respond_to(:public_method_response)
    end

    it "writes the view to the response io when a xxxxx_response method is called" do
      subject.public_method_response
      response.close
      io.rewind
      data = HTTP::Client::Response.from_io(io)
      expect(data.body).to eq("[1,2,3]")
    end

    it "does not create xxxxx_response methods for private methods" do
      expect(subject).not_to respond_to(:private_method_response)
    end
  end
end
