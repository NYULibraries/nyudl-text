require 'spec_helper'

describe Nyudl::Text::PageNumber do

  context "when object is instantiated" do
    subject { Nyudl::Text::PageNumber.new() }

    its(:class)  { should == Nyudl::Text::PageNumber }
    its(:acc_rf) { should == '\d{3,6}' }
    its(:out_rf) { should == 'n\d{6}' }
  end

  describe "#fmt" do
    subject {Nyudl::Text::PageNumber.new().fmt('001')}
    it { should == 'n000001' }
  end

end
