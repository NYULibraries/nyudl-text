require 'spec_helper'
require 'fakefs/safe'

describe Nyudl::Text::Base do

  context "when an object is instantiated" do
    subject { Nyudl::Text::Base.new('.', 'b') }
    its(:class) { should == Nyudl::Text::Base }
  end

  describe "#valid?", fakefs: true do
    def stub_valid_text_dir
      FileUtils.mkdir("/b")
      File.open("/b/b_n000001_m.tif", "w") do |f|
        f.puts("hohoho")
      end
    end

    def stub_invalid_text_dir
      FileUtils.mkdir("/b")
      File.open("/b/b_000001m.tif", "w") do |f|
        f.puts("hohoho")
      end
    end

    it "returns nil" do
      stub_valid_text_dir
      t = Nyudl::Text::Base.new('/b', 'b')
      t.valid?.should be_nil
    end

    it "return true if valid after analyze call" do
      stub_valid_text_dir
      t = Nyudl::Text::Base.new('/b', 'b')
      t.analyze
      t.valid?.should be_true
    end

    it "return false if valid after analyze call" do
      stub_invalid_text_dir
      t = Nyudl::Text::Base.new('/b', 'b')
      t.analyze
      t.valid?.should be_false
    end
  end


  context "when text is valid" do
    it "#check returns true"
    it "#rename? returns false"
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

