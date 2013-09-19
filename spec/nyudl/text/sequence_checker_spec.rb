require 'spec_helper'

describe Text::SequenceChecker do
  context "when an object is instantiated" do
    subject { Text::SequenceChecker.new() }

    its(:class)  { should == Text::SequenceChecker }
  end

end
