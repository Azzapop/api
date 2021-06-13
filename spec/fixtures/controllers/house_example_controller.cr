require "../../../src/controllers/base_controller"

class HouseExampleController < BaseController
  def get
  end

  def head
    @response.headers.add("head", "head")
  end

  def post
  end

  def put
  end

  def delete
  end

  def connect
  end

  def options
  end

  def trace
  end

  def patch
  end
end
