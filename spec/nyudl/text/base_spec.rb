require 'spec_helper'
require 'fakefs/safe'

describe Nyudl::Text::Base do

  # this text is good as it is, no renaming required
  def stub_valid_text
    FileUtils.mkdir("/b")
    File.open("/b/b_n000001_m.tif", "w") do |f|
      f.puts("hohoho")
    end
    Nyudl::Text::Base.new('/b', 'b')
  end

  # this text does not conform to the naming convention,
  # but all files are recognized and can be renamed
  def stub_recognized_text
    FileUtils.mkdir("/b")
    File.open("/b/b_000001m.tif", "w") do |f|
      f.puts("hohoho")
    end
    Nyudl::Text::Base.new('/b', 'b')
  end

  # this text does not conform to the naming convention,
  # but all files are recognized and can be renamed
  def stub_unrecognized_text
    FileUtils.mkdir("/b")
    FileUtils.touch("/b/b_000001_m.tif")
    FileUtils.touch("/b/asdfasd")
    Nyudl::Text::Base.new('/b', 'b')
  end


  describe "when an object is instantiated" do
    subject { Nyudl::Text::Base.new('.', 'b') }
    its(:class) { should == Nyudl::Text::Base }
  end


  describe "#valid?", fakefs: true do

    context "with valid text" do
      subject(:text) { stub_valid_text }
      it "returns nil if called before #analyze" do
        text.valid?.should == nil
      end
      it "returns true if valid and called after #analyze" do
        text.analyze
        text.valid?.should be_true
      end
    end

    context "with text that needs renaming" do
      subject(:text) { stub_recognized_text }
      it "returns false if renaming required and called after #analyze" do
        text.analyze
        text.valid?.should be_false
      end
    end
  end


  describe "#analyze", fakefs: true do
    context "with any text" do
      subject(:text) { stub_valid_text }
      it "always returns nil" do
        text.analyze.should == nil
      end
      subject(:text) { stub_recognized_text }
      it "always returns nil" do
        text.analyze.should == nil
      end
      subject(:text) { stub_unrecognized_text }
      it "always returns nil" do
        text.analyze.should == nil
      end
    end
  end


  describe "#errors", fakefs: true do
    context "with valid text" do
      subject(:text) { stub_valid_text }

      it "returns nil if text not analyzed yet" do
        text.errors.should == nil
      end

      it "returns a Hash after text analyzed" do
        text.analyze
        text.errors.class.should == Hash
      end

      it "returns an empty Hash after text analyzed" do
        text.analyze
        text.errors.should be_empty
      end

      # it "returns an empty Hash after text analyzed hohoho" do
      #   text.analyze
      #   text.errors[:bobo]
      #   text.errors.should be_empty
      # end
    end

    context "with unrecognized text" do
      subject(:text) { stub_unrecognized_text }

      it "returns nil if text not analyzed yet" do
        text.errors.should == nil
      end

      it "returns a Hash after text analyzed" do
        text.analyze
        text.errors.class.should == Hash
      end

      it "returns a Hash with unrecognized key after text analyzed" do
        text.analyze
        text.errors.keys.should == [:unrecognized]
      end

      it "returns an Array with the unrecognized filename when queried with :unrecognized key" do
        text.analyze
        text.errors(:unrecognized).class.should == Array
        text.errors(:unrecognized).should == ['/b/asdfasd']
      end
    end


  end

  describe "#rename?", fakefs: true do
    context "with valid text" do
      subject (:text) { stub_valid_text }
      it "returns false" do
        text.rename?.should be_false
      end
    end

    context "with valid text" do
      subject (:text) { stub_valid_text }
      it "returns false" do
        text.rename?.should be_false
      end
    end
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

