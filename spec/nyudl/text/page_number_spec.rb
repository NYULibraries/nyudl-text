require 'spec_helper'

describe Text::PageNumber do

  context "when object is instantiated" do
    subject { Text::PageNumber.new() }

    its(:class)  { should == Text::PageNumber }
    its(:acc_rf) { should == '\d{3,6}' }
    its(:out_rf) { should == 'n\d{6}' }
  end

  describe "#fmt" do
    subject {Text::PageNumber.new().fmt('001')}
    it { should == 'n000001' }
  end

end
