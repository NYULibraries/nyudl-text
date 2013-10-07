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


  describe "#new", fakefs: true do

    context "when an object is instantiated with a valid directory" do
      subject { FileUtils.mkdir("/b"); Nyudl::Text::Base.new('/b', 'b') }
      its(:class) { should == Nyudl::Text::Base }
    end
    context "when an object is instantiated with an invalid directory" do
      it "raises an exception" do
        expect { Nyudl::Text::Base.new('dir-DNE', 'b') }.to raise_error ArgumentError
      end
    end
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


  describe "#analyzed?", fakefs: true do
    context "with any text" do
      subject(:text) { stub_valid_text }
      it "returns false when called before #analyze" do
        text.analyzed?.should == false
      end
      it "returns true when called after #analyze" do
        text.analyze
        text.analyzed?.should == true
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

      # this test added b/c early implementation added an Array to the Hash
      #   even for non-existant keys
      it "returns an empty Hash even after a query for a non-existant key" do
        text.analyze
        text.errors(:bobo)
        text.errors.should be_empty
      end
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
    context "returns nil if called before #analyze" do
      subject (:text) { stub_valid_text }
      it "returns false" do
        text.rename?.should be_nil
      end
    end

    context "with valid text" do
      subject (:text) { stub_valid_text }
      it "returns false" do
        text.analyze
        text.rename?.should be_false
      end
    end

    context "with recognized text" do
      subject (:text) { stub_recognized_text }
      it "returns true" do
        text.analyze
        text.rename?.should be_true
      end
    end

    context "with unrecognized text" do
      subject (:text) { stub_unrecognized_text }
      it "returns true" do
        text.analyze
        text.rename?.should be_true
      end
    end

  end


  describe "#rename!", fakefs: true do
    context "when given a valid text" do
      subject(:text) { stub_valid_text }
      it "raises an exception if called before #analyze" do
        expect {text.rename!}.to raise_error RuntimeError
      end
      it "does nothing when called after #analyze" do
        text.analyze
        text.valid?.should be_true
        text.rename?.should be_false
        text.errors.should be_empty
        text.rename!
        text.analyze
        text.valid?.should be_true
        text.rename?.should be_false
        text.errors.should be_empty
      end
    end

    context "when given a recognized text" do
      subject(:text) { stub_recognized_text }
      it "renames the files" do
        text.analyze
        text.valid?.should be_false
        text.rename?.should be_true
        text.errors.should be_empty
        text.rename!
        text.analyzed?.should be_false
        text.analyze
        text.valid?.should be_true
        text.rename?.should be_false
        text.errors.should be_empty
      end
    end

    context "when given an unrecognized text" do
      subject(:text) { stub_unrecognized_text }
      it "renames the files" do
        text.analyze
        text.valid?.should be_false
        text.rename?.should be_true
        text.errors.should_not be_empty
        expect {text.rename!}.to raise_error RuntimeError
      end
    end
  end



  describe "#rename_plan", fakefs: true do

    context "with any text" do
      subject(:text) { stub_recognized_text }
      it "returns nil if text hasn't been analyzed" do
        text.rename_plan.should be_nil
      end
    end

    context "with a valid text" do
      subject(:text) { stub_valid_text }
      it "returns []" do
        text.analyze
        text.rename_plan.should == []
      end
    end

    context "with a recognized text" do
      subject(:text) { stub_recognized_text }
      it "returns the proper rename plan" do
        text.analyze
        text.rename_plan.should == [{old_name: '/b/b_000001m.tif', new_name: '/b/b_n000001_m.tif'}]
      end
    end

    context "with an unrecognized text" do
      subject(:text) { stub_unrecognized_text }
      it "raises RuntimeError" do
        text.analyze
        expect {text.rename_plan}.to raise_error(RuntimeError)
      end
    end
  end
end

