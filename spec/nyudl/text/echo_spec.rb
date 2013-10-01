require 'spec_helper'

describe Nyudl::Text::Echo do
  describe "#echo" do
    it "should say HOHOHO!" do
      Nyudl::Text::Echo.hohoho.should == "HOHOHO!"
    end
  end
end

