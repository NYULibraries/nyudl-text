require 'spec_helper'

describe Nyudl::Text::Errors do
  def create_errors_object
    Nyudl::Text::Errors.new()
  end

  subject(:e) { create_errors_object }

  describe "#initialize" do
    it "returns an object of the correct class" do
      e.class.should == Nyudl::Text::Errors
    end
  end

  describe "#add" do
    it "adds the error message to an array with the correct key" do
      e.add(:foo, 'bar')
      e.on(:foo).should == ['bar']
      e.add(:baz, 'quux')
      e.on(:baz).should == ['quux']
    end
  end

  describe "#all" do
    subject(:e) {
      eo = Nyudl::Text::Errors.new()
      eo.add(:foo, 'bar')
      eo.add(:baz, 'quux')
      eo
    }

    it "returns a Hash" do
      e.all.class.should == Hash
    end
    it "returns a Hash with all expected keys" do
      e.all.keys.sort.should == [:baz, :foo]
    end
    it "returns a Hash with all expected sub-arrays" do
      e.all.values.sort.should == [['bar'], ['quux']]
    end
  end

  describe "converts String keys to Symbols" do
    subject(:e) { 
      eo = Nyudl::Text::Errors.new()
      eo.add(:foo, 'bar')
      eo
    }

    it "returns the expected value using a String key" do
      e.on('foo').should == ['bar']
    end

    it "returns the expected value using a Symbol key" do
      e.on(:foo).should == ['bar']
    end
  end
end

