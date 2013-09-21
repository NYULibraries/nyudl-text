require 'spec_helper'

describe Nyudl::Text::FrontMatterNumber do

  context "when object is instantiated" do
    subject { Nyudl::Text::FrontMatterNumber.new() }

    its(:class)  { should == Nyudl::Text::FrontMatterNumber }
    its(:acc_rf) { should == 'fr\d{2,2}' }
    its(:out_rf) { should == 'afr\d{2}'  }
  end

  context "when object is instantiated with options" do
    subject { Nyudl::Text::FrontMatterNumber.new(fr_digits_max: 3, fr_digits_out: 4) }

    its(:acc_rf) { should == 'fr\d{2,3}' }
    its(:out_rf) { should == 'afr\d{4}'  }
  end

  describe "#fmt" do
    subject {Nyudl::Text::FrontMatterNumber.new(fr_digits_max: 3, fr_digits_out: 4).fmt('fr009')}
    it { should == 'afr0009' }
  end

  it "should raise exception if max fr input digits > max fr  output digits" do
    expect {Nyudl::Text::FrontMatterNumber.new(:fr_digits_max => 3, :fr_digits_out => 2)}.to raise_error(RuntimeError, "invalid parameters: fr_digits_max > fr_digits_out")
  end

  it "should raise exception if unable to extract front matter number" do
    expect {Nyudl::Text::FrontMatterNumber.new().fmt('quux')}.to raise_error(RuntimeError, "unable to extract front matter number")
  end

end
