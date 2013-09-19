require 'spec_helper'

describe Text::Filename do


  context "when object is instantiated" do
    subject { Text::Filename.new('mss092_ref14_000068m.tif', 'mss092_ref14') }

    its(:class) { should == Text::Filename }
    it { should be_recognized }
    it { should be_rename    }
    its(:newname) { should == 'mss092_ref14_n000068_m.tif'}
  end

  context "when prefix does not match" do
    subject { Text::Filename.new('mss092_ref14_000068m.tif', 'mss092_14') }

    it { should_not be_recognized }
    its(:rename?) { should be_nil }
  end

  context "when filename is already correct" do
    subject { Text::Filename.new('mss092_ref14_n000068_m.tif', 'mss092_ref14') }

    it { should be_recognized }
    it { should_not be_rename }
  end

  context "when filename is already correct using non-default number of front matter output digits"
  context "when filename is already correct using non-default number of back  matter output digits"


  context "when filename has only three digits for page number" do
    subject { Text::Filename.new('ifa_egypt0018_017m.tif', 'ifa_egypt0018') }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'ifa_egypt0018_n000017_m.tif'}
  end

  context "when filename has only three digits for page number and an insert" do
    subject { Text::Filename.new('ifa_egypt0018_017_20d.tif', 'ifa_egypt0018') }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'ifa_egypt0018_n000017_z20_d.tif'}
  end

  context "when filename has only three digits for page number and an oversize" do
    subject { Text::Filename.new('ifa_egypt0018_017_20_10d.tif', 'ifa_egypt0018') }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'ifa_egypt0018_n000017_z20_z10_d.tif'}
  end

  context "when filename has only three digits for page number and an oversize" do
    subject { Text::Filename.new('ifa_egypt0018_017_20_10d.tif', 'ifa_egypt0018') }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'ifa_egypt0018_n000017_z20_z10_d.tif'}
  end


  #-----------------------------------------------------------------

  context "when using back matter with 3 digits in input filename" do
    subject { Text::Filename.new('mss092_ref14_bk001d.tif', 'mss092_ref14', :bk_digits_max => 2) }

    it { should_not be_recognized }
  end

  context "when using back matter with 3 digits in input filename" do
    subject { Text::Filename.new('mss092_ref14_bk001d.tif', 'mss092_ref14', :bk_digits_max => 3, :bk_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_zbk001_d.tif'}
  end

  context "when using back matter coercing to 3 digits in output filename" do
    subject { Text::Filename.new('mss092_ref14_bk01d.tif', 'mss092_ref14', :bk_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_zbk001_d.tif'}
  end

  context "when using back matter and insert coercing to 3 digits in output filename" do
    subject { Text::Filename.new('mss092_ref14_bk01_01d.tif', 'mss092_ref14', :bk_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_zbk001_z01_d.tif'}
  end

  context "when using back matter and oversize coercing to 3 digits in output filename" do
    subject { Text::Filename.new('mss092_ref14_bk01_02_01d.tif', 'mss092_ref14', :bk_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_zbk001_z02_z01_d.tif'}
  end


  #-----------------------------------------------------------------


  context "when using front matter with 3 digits in input filename" do
    subject { Text::Filename.new('mss092_ref14-fr001d.tif', 'mss092_ref14', :fr_digits_max => 2) }

    it { should_not be_recognized }
  end

  context "when using front matter with 3 digits in input filename" do
    subject { Text::Filename.new('mss092_ref14-fr001d.tif', 'mss092_ref14', :fr_digits_max => 3, :fr_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_afr001_d.tif'}
  end

  context "when using front matter coercing to 3 digits in output filename" do
    subject { Text::Filename.new('mss092_ref14-fr01d.tif', 'mss092_ref14', :fr_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_afr001_d.tif'}
  end


  context "when using front matter and insert coercing to 3 digits in output filename" do
    subject { Text::Filename.new('mss092_ref14-fr01_01d.tif', 'mss092_ref14', :fr_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_afr001_z01_d.tif'}
  end

  context "when using front matter and oversize coercing to 3 digits in output filename" do
    subject { Text::Filename.new('mss092_ref14-fr01_02_01d.tif', 'mss092_ref14', :fr_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_afr001_z02_z01_d.tif'}
  end





  #-----------------------------------------------------------------

  context "when new_prefix is nil" do
    subject { Text::Filename.new('mss092_ref14_000068m.tif', 'mss092_ref14', :new_prefix => nil) }

    its(:newname) { should == 'mss092_ref14_n000068_m.tif'}
  end


  context "when using new_prefix option with correct filename" do
    subject { Text::Filename.new('mss092_ref14_n000068_m.tif', 'mss092_ref14', :new_prefix => 'foo') }

    it { should be_recognized }
    its(:newname) { should == 'foo_n000068_m.tif'}
    it { should be_rename }
  end

  context "when new_prefix is nil" do
    subject { Text::Filename.new('mss092_ref14_000068m.tif', 'mss092_ref14', :new_prefix => nil) }

    it { should be_recognized }
    its(:newname) { should == 'mss092_ref14_n000068_m.tif'}
  end



  context "when using an invalid filename" do
    subject { Text::Filename.new('mss092_ref14_axnasdflasdf.tif', 'mss092_ref14') }

    it { should_not be_recognized }
  end

  context "when using a PASSING regression-test filename" do
    subject { Text::Filename.new('woj_ref22_000078_07_d.tif', 'woj_ref22') }

    it { should be_recognized }
    its(:newname) { should == 'woj_ref22_n000078_z07_d.tif'}
  end

  context "when README.txt file is found" do
    subject { Text::Filename.new('README.txt', 'mss092_ref14') }

    it { should be_recognized }
    it { should_not be_rename }
  end

  # this is because, for some reason, Ruby can correctly convert numbers 0-7 
  # to_i if they have a leading zero, but hit 08 and all bets are off.
  # probably b/c 00 -> 07 Octal are valid, but 08 is not valid Octal and
  # would be written 010.  Need to implement fix to strip leading zeros...
  # http://www.ruby-forum.com/topic/62141
  context "when using a FAILING regression-test filename" do
    subject { Text::Filename.new('woj_ref22_000078_08_d.tif', 'woj_ref22') }

    it { should be_recognized }
    its(:newname) { should == 'woj_ref22_n000078_z08_d.tif'}
  end

  context "when using a FAILING regression-test filename" do
    subject { Text::Filename.new('woj_ref22_000058_08_08_d.tif', 'woj_ref22') }

    it { should be_recognized }
    its(:newname) { should == 'woj_ref22_n000058_z08_z08_d.tif'}
  end


  # add test for 3 digit insert and oversize
  # should not be recognized, then when tested with increased max digits should be OK

  context "when using insert with 3 digits in input filename" do
    subject { Text::Filename.new('mss092_ref14-fr01_999d.tif', 'mss092_ref14') }

    it { should_not be_recognized }
  end

  context "when using insert with 3 digits in input filename and larger max digits and output digits" do
    subject { Text::Filename.new('mss092_ref14-fr01_999d.tif', 'mss092_ref14', :in_digits_max => 3, :in_digits_out => 4) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_afr01_z0999_d.tif'}
  end



  prefix = 'mss092_ref14'
  {
    "mss092_ref14_000068m.tif" => "mss092_ref14_n000068_m.tif",
    "mss092_ref14-fr01d.tif"   => "mss092_ref14_afr01_d.tif",
    "mss092_ref14_fr01d.tif"   => "mss092_ref14_afr01_d.tif",
    "mss092_ref14_bk01m.tif"   => "mss092_ref14_zbk01_m.tif",

    "mss092_ref14_000068_1m.tif" => "mss092_ref14_n000068_z01_m.tif",
    "mss092_ref14-fr01_1d.tif"   => "mss092_ref14_afr01_z01_d.tif",
    "mss092_ref14_fr01_1d.tif"   => "mss092_ref14_afr01_z01_d.tif",
    "mss092_ref14_bk01_1m.tif"   => "mss092_ref14_zbk01_z01_m.tif",

    "mss092_ref14_000068_1_1m.tif"  => "mss092_ref14_n000068_z01_z01_m.tif",
    "mss092_ref14-fr01_1_01d.tif"   => "mss092_ref14_afr01_z01_z01_d.tif",
    "mss092_ref14_fr01_1_01d.tif"   => "mss092_ref14_afr01_z01_z01_d.tif",
    "mss092_ref14_bk01_1_1m.tif"    => "mss092_ref14_zbk01_z01_z01_m.tif",

    "mss092_ref14_targetm.tif"      => "mss092_ref14_ztarget_m.tif",
    "mss092_ref14_target.tif"       => "mss092_ref14_ztarget_m.tif",

    "mss092_ref14_n000068_m.tif" => "mss092_ref14_n000068_m.tif",
    "mss092_ref14_afr01_d.tif"   => "mss092_ref14_afr01_d.tif",
    "mss092_ref14_zbk01_m.tif"   => "mss092_ref14_zbk01_m.tif",

    "mss092_ref14_n000068_z08_m.tif" => "mss092_ref14_n000068_z08_m.tif",
    "mss092_ref14_afr01_z08_d.tif"   => "mss092_ref14_afr01_z08_d.tif",
    "mss092_ref14_zbk01_z08_m.tif"   => "mss092_ref14_zbk01_z08_m.tif",

    "mss092_ref14_n000068_z08_z08_m.tif" => "mss092_ref14_n000068_z08_z08_m.tif",
    "mss092_ref14_afr01_z08_z08_d.tif"   => "mss092_ref14_afr01_z08_z08_d.tif",
    "mss092_ref14_zbk01_z08_z08_m.tif"   => "mss092_ref14_zbk01_z08_z08_m.tif"
  }.each_pair do |k,v|
    context "when using known filename patterns" do
      subject(:fname) { Text::Filename.new(k, prefix) }
      it { should be_recognized }
      its(:newname) { should == v }
    end
  end
end

