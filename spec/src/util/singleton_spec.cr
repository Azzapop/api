require "../../spec_helper"

class House
  include Singleton

  def self.new_house
    new
  end
end

Spectator.describe Singleton do
  it "should have a constant that is an instance" do
    expect(House::INSTANCE).to be_a(House)
  end

  pending "should not allow a new instance to be created in included classes" do
    expect_raises(Singleton::SingletonException) { House.new_house }
  end

  it "should not allow an instance to be duplicated" do
    expect_raises(Singleton::SingletonException) { House::INSTANCE.dup }
  end

  it "should not allow an instance to be cloned" do
    expect_raises(Singleton::SingletonException) { House::INSTANCE.clone }
  end
end

