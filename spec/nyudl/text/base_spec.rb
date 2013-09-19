require 'spec_helper'

describe Text::Base do
  context "when an object is instantiated" do
    subject { Text::Base.new() }

    its(:class) { should == Text::Base }
  end
  context "when some files need renaming" do
    it "#rename! only files requiring rename"
    it "#renames returns empty hash when there are no renames"
    it "#rename? returns true  when    renames required"
    it "#rename? returns false when no renames required"
    it "#errors  returns errors keyed by analysis type: unrecognized filenames, slot errors, sequence errors. "
    it "#analyze  returns true  if there are no  errors"
    it "#analyze  returns false if there are any errors"
    it "#analyze!  raises an exception if there are any errors"
    it "#analyzed? returns true if analysis was run"
    it "#analyzed? returns false after a rename operation" # is this correct/expected?
    it "#valid? returns" 
    it ".initialize raises an exception if the argument is not a directory"
    it ".initialize raises" 
  end
end

