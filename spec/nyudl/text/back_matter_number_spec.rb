require 'spec_helper'

describe Nyudl::Text::BackMatterNumber do

  context "when object is instantiated" do
    subject { Nyudl::Text::BackMatterNumber.new() }

    its(:class)  { should == Nyudl::Text::BackMatterNumber }
    its(:acc_rf) { should == 'bk\d{2,2}' }
    its(:out_rf) { should == 'zbk\d{2}'  }
  end

  context "when object is instantiated with options" do
    subject { Nyudl::Text::BackMatterNumber.new(bk_digits_max: 3, bk_digits_out: 4) }

    its(:acc_rf) { should == 'bk\d{2,3}' }
    its(:out_rf) { should == 'zbk\d{4}'  }
  end

  describe "#fmt" do
    subject {Nyudl::Text::BackMatterNumber.new(bk_digits_max: 3, bk_digits_out: 4).fmt('bk009')}
    it { should == 'zbk0009' }
  end

  it "should raise exception if max bk input digits > max bk  output digits" do
    expect {Nyudl::Text::BackMatterNumber.new(:bk_digits_max => 3, :bk_digits_out => 2)}.to raise_error(RuntimeError, "invalid parameters: bk_digits_max > bk_digits_out")
  end

  it "should raise exception if unable to extract back matter number" do
    expect {Nyudl::Text::BackMatterNumber.new().fmt('quux')}.to raise_error(RuntimeError, "unable to extract back matter number")
  end

end
