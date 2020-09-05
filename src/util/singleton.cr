#######################################
#
# There are currently some trade offs to the way that singletons can be implemented
# in crystal-lang at the moment
#
# A constant is guaranteed to be a singleton at compile time, however there is no way to check
# inside of the `new` method whether it is being called for the first time (without passing weird
# params that can be worked around in the including class), or checking if a value has already been
# set without creating an infinite recursive loop
#
#
# TODO One option which I have considered but haven't looked into yet is creating a custom `new`
# method and tracking whether the memory for an instance is set, and raising the error if that works
# out to be true
#
# TODO add a macro such that if the including class module defines one of the over-ridden methods
# then it prevents it/raises an error
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
