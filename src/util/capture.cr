module Capture(T)
  def self.block(&block : T) : T
    block
  end
end
