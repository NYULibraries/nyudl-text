require 'spec_helper'

describe Text::InsertNumber do

  context "when object is instantiated" do
    subject { Text::InsertNumber.new() }

    its(:class)  { should == Text::InsertNumber }
    its(:acc_rf) { should == '\d{1,2}' }
    its(:out_rf) { should == 'z\d{2}'  }
  end

  context "when object is instantiated with options" do
    subject { Text::InsertNumber.new(in_digits_max: 3, in_digits_out: 4) }

    its(:acc_rf) { should == '\d{1,3}' }
    its(:out_rf) { should == 'z\d{4}'  }
  end

  describe "#fmt" do
    subject {Text::InsertNumber.new(in_digits_max: 3, in_digits_out: 4).fmt('009')}
    it { should == 'z0009' }
  end

  it "should raise exception if max in input digits > max in  output digits" do
    expect {Text::InsertNumber.new(:in_digits_max => 3, :in_digits_out => 2)}.to raise_error(RuntimeError, "invalid parameters: in_digits_max > in_digits_out")
  end

  it "should raise exception if unable to extract back matter number" do
    expect {Text::InsertNumber.new().fmt('quux')}.to raise_error(RuntimeError, "unable to extract insert number")
  end

end
