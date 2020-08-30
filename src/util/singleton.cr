#######################################
#
# There are currently some trade offs to the way that singletons can be implemented
# in crystal-lang at the moment.
# TODO more in depth description of why this implementation was chosen
#
#######################################
module Singleton
  class SingletonException < Exception
    def initialize(message = "Singleton exception occurred")
      super(message)
    end
  end

  macro included
    INSTANCE = new
  end

  private def initialize
  end

  def dup
    raise SingletonException.new("Can't call `dup` on a singleton")
  end

  def clone
    raise SingletonException.new("Cannot call `clone` on a singleton")
  end
end
