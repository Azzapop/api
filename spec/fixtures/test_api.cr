require "../../src/routes"
require "./controllers/*"

module Api
  include Routes

  get("/houses", HouseExampleController, :get)
  head("/houses", HouseExampleController, :head)
  post("/house", HouseExampleController, :post)
  put("/house/:id", HouseExampleController, :put)
  delete("/house/:id", HouseExampleController, :delete)
  connect("/houses", HouseExampleController, :connect)
  options("/houses/options", HouseExampleController, :options)
  trace("/houses", HouseExampleController, :trace)
  patch("/house/:id", HouseExampleController, :patch)
end
