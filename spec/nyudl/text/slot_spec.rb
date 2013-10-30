require 'spec_helper'

describe Nyudl::Text::Slot do

  # # this text is good as it is, no renaming required
  # def stub_empty_text
  #   FileUtils.mkdir("/b")
  #   Nyudl::Text::Base.new('/b', 'b')
  # end

  def stub_master_filename
    Nyudl::Text::Filename.new('mss092_ref14_000068m.tif', 'mss092_ref14') 
  end

  def stub_dmaker_filename
    Nyudl::Text::Filename.new('mss092_ref14_000068d.tif', 'mss092_ref14') 
  end

  def stub_oversized_master_1_filename
    Nyudl::Text::Filename.new('mss092_ref14_000068_01m.tif', 'mss092_ref14') 
  end

  def stub_oversized_master_2_filename
    Nyudl::Text::Filename.new('mss092_ref14_000068_02m.tif', 'mss092_ref14') 
  end


  def stub_raw_slot
    Nyudl::Text::Slot.new()
  end

  def stub_valid_slot
    Nyudl::Text::Slot.new({type: 'page', location: 'top'})
  end

  def stub_slot_with_invalid_location
    Nyudl::Text::Slot.new({type: 'page', location: 'FOO'})
  end

  def stub_slot_with_invalid_type
    Nyudl::Text::Slot.new({type: 'FOO', location: 'top'})
  end

  def stub_slot_with_invalid_location_and_invalid_type
    Nyudl::Text::Slot.new({type: 'FOO', location: 'BAR'})
  end


  # # this text does not conform to the naming convention,
  # # but all files are recognized and can be renamed
  # def stub_unrecognized_text
  #   FileUtils.mkdir("/b")
  #   FileUtils.touch("/b/b_000001_m.tif")
  #   FileUtils.touch("/b/asdfasd")
  #   Nyudl::Text::Base.new('/b', 'b')
  # end
  describe "#new" do
    context "when a slot is instantiated with valid type and location" do
      subject(:slot) { stub_valid_slot }
      its(:class) { should == Nyudl::Text::Slot }
    end

    context "when a slot is instantiated without any parameters" do
      it "doesn't raise an exception" do
        expect { Nyudl::Text::Slot.new() }.not_to raise_error
      end
    end
  end
  describe "#errors" do
    context "when a slot is instantiated with an invalid location" do
      subject(:slot) { stub_slot_with_invalid_location }
      it ":location array should not be empty" do
        expect(slot.errors[:location]).to eq(["invalid location: FOO"])
      end
    end
    context "when a slot is instantiated with an invalid type" do
      subject(:slot) { stub_slot_with_invalid_type }
      it ":type array should not be empty" do
        expect(slot.errors[:type]).to eq(["invalid type: FOO"])
      end
    end
    context "when a slot is instantiated with an invalid location and invalid type" do
      subject(:slot) { stub_slot_with_invalid_location_and_invalid_type }
      it ":type array should not be empty" do
        expect(slot.errors).to eq({:location => ["invalid location: BAR"],
                                    :type     => ["invalid type: FOO"]})
      end
    end
  end

  describe "#recognized?" do
    context "when a slot is instantiated with an invalid location" do
      subject(:slot) { stub_slot_with_invalid_location }
      it "is not recognized" do
        expect(slot.recognized?).to eq(false)
      end
    end
    context "when a slot is instantiated with valid parameters, but no files" do
      subject(:slot) { stub_valid_slot }
      it "is not recognized" do
        expect(slot.recognized?).to eq(false)
      end
    end
  end

  describe "#<<" do
    context "when a slot is instantiated without any parameters" do
      subject(:slot) { stub_raw_slot }
      it "doesn't have any files" do
        expect(slot.files).to eq({})
      end
      it "can add files" do
        expect(slot.files).to eq({})
        f1 = stub_master_filename
        slot << f1
        expect(slot.files).to eq({f1.role => [f1]})
      end
      it "can add files with different roles" do
        f1 = stub_master_filename
        f2 = stub_dmaker_filename
        slot << f1
        expect(slot.files).to eq({f1.role => [f1]})
        slot << f2
        expect(slot.files).to eq({f1.role => [f1], f2.role => [f2]})
      end
      it "can add files with the same roles" do
        m1 = stub_oversized_master_1_filename
        m2 = stub_oversized_master_2_filename
        d1 = stub_dmaker_filename
        slot << m1
        expect(slot.files).to eq({m1.role => [m1]})
        slot << m2
        expect(slot.files).to eq({m1.role => [m1, m2]})
        slot << d1
        expect(slot.files).to eq({m1.role => [m1, m2], d1.role => [d1]})
      end

    end
  end

end
