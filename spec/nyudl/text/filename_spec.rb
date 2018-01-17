require 'spec_helper'

describe Nyudl::Text::Filename do

  describe ".relationship" do
    context "when given the same file name" do
      subject { Nyudl::Text::Filename.relationship('a','a') }
      it { should == :identical }
    end
    context "when given dmaker and master for same slot" do
      subject { Nyudl::Text::Filename.relationship('mss092_ref14_afr01_z08_m.tif','mss092_ref14_afr01_z08_d.tif') }
      it { should == :same_slot }
    end
    context "when given dmaker for oversized and master for part" do
      subject { Nyudl::Text::Filename.relationship('mss092_ref14_afr01_d.tif','mss092_ref14_afr01_z08_m.tif') }
      it { should == :parent }
    end
    context "when given dmaker for oversized and master for part" do
      subject { Nyudl::Text::Filename.relationship('mss092_ref14_afr01_z08_m.tif','mss092_ref14_afr01_d.tif') }
      it { should == :child }
    end
    context "when given dmaker for oversized and master for part" do
      subject { Nyudl::Text::Filename.relationship('mss092_ref14_afr02_d.tif','mss092_ref14_afr01_z08_m.tif') }
      it { should == :unknown }
    end
  end

  context "when object is instantiated" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_000068m.tif', 'mss092_ref14') }

    its(:class) { should == Nyudl::Text::Filename }
    it { should be_recognized }
    it { should be_rename    }
    its(:newname) { should == 'mss092_ref14_n000068_m.tif'}
    its(:role) {should == 'master'}
  end

  context "when prefix does not match" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_000068m.tif', 'mss092_14') }

    it { should_not be_recognized }
    its(:rename?) { should be_nil }
  end

  context "when filename is already correct" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_n000068_m.tif', 'mss092_ref14') }

    it { should be_recognized }
    it { should_not be_rename }
  end

  context "when filename is already correct using non-default number of front matter output digits"
  context "when filename is already correct using non-default number of back  matter output digits"


  context "when filename has only three digits for page number" do
    subject { Nyudl::Text::Filename.new('ifa_egypt0018_017m.tif', 'ifa_egypt0018') }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'ifa_egypt0018_n000017_m.tif'}
  end

  context "when filename has only three digits for page number and an insert" do
    subject { Nyudl::Text::Filename.new('ifa_egypt0018_017_20d.tif', 'ifa_egypt0018') }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'ifa_egypt0018_n000017_z20_d.tif'}
  end

  context "when filename has only three digits for page number and an oversize" do
    subject { Nyudl::Text::Filename.new('ifa_egypt0018_017_20_10d.tif', 'ifa_egypt0018') }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'ifa_egypt0018_n000017_z20_z10_d.tif'}
  end

  context "when filename has only three digits for page number and an oversize" do
    subject { Nyudl::Text::Filename.new('ifa_egypt0018_017_20_10d.tif', 'ifa_egypt0018') }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'ifa_egypt0018_n000017_z20_z10_d.tif'}
  end


  #-----------------------------------------------------------------

  context "when using back matter with 3 digits in input filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_bk001d.tif', 'mss092_ref14', :bk_digits_max => 2) }

    it { should_not be_recognized }
  end

  context "when using back matter with 3 digits in input filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_bk001d.tif', 'mss092_ref14', :bk_digits_max => 3, :bk_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_zbk001_d.tif'}
  end

  context "when using back matter coercing to 3 digits in output filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_bk01d.tif', 'mss092_ref14', :bk_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_zbk001_d.tif'}
  end

  context "when using back matter and insert coercing to 3 digits in output filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_bk01_01d.tif', 'mss092_ref14', :bk_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_zbk001_z01_d.tif'}
  end

  context "when using back matter and oversize coercing to 3 digits in output filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_bk01_02_01d.tif', 'mss092_ref14', :bk_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_zbk001_z02_z01_d.tif'}
  end


  #-----------------------------------------------------------------


  context "when using front matter with 3 digits in input filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14-fr001d.tif', 'mss092_ref14', :fr_digits_max => 2) }

    it { should_not be_recognized }
  end

  context "when using front matter with 3 digits in input filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14-fr001d.tif', 'mss092_ref14', :fr_digits_max => 3, :fr_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_afr001_d.tif'}
  end

  context "when using front matter coercing to 3 digits in output filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14-fr01d.tif', 'mss092_ref14', :fr_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_afr001_d.tif'}
  end


  context "when using front matter and insert coercing to 3 digits in output filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14-fr01_01d.tif', 'mss092_ref14', :fr_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_afr001_z01_d.tif'}
  end

  context "when using front matter and oversize coercing to 3 digits in output filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14-fr01_02_01d.tif', 'mss092_ref14', :fr_digits_out => 3) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_afr001_z02_z01_d.tif'}
  end





  #-----------------------------------------------------------------

  context "when new_prefix is nil" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_000068m.tif', 'mss092_ref14', :new_prefix => nil) }

    its(:newname) { should == 'mss092_ref14_n000068_m.tif'}
  end


  context "when using new_prefix option with correct filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_n000068_m.tif', 'mss092_ref14', :new_prefix => 'foo') }

    it { should be_recognized }
    its(:newname) { should == 'foo_n000068_m.tif'}
    it { should be_rename }
  end

  context "when new_prefix is nil" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_000068m.tif', 'mss092_ref14', :new_prefix => nil) }

    it { should be_recognized }
    its(:newname) { should == 'mss092_ref14_n000068_m.tif'}
  end



  context "when using an invalid filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_axnasdflasdf.tif', 'mss092_ref14') }

    it { should_not be_recognized }
  end

  context "when using a PASSING regression-test filename" do
    subject { Nyudl::Text::Filename.new('woj_ref22_000078_07_d.tif', 'woj_ref22') }

    it { should be_recognized }
    its(:newname) { should == 'woj_ref22_n000078_z07_d.tif'}
  end

  context "when README.txt file is found" do
    subject { Nyudl::Text::Filename.new('README.txt', 'mss092_ref14') }

    it { should be_recognized }
    it { should_not be_rename }
  end

  context "when <DIGID>_eoc.csv file is found" do
    subject { Nyudl::Text::Filename.new('mss092_ref14_eoc.csv', 'mss092_ref14') }

    it { should be_recognized }
    it { should_not be_rename }
  end

  context "when EOC.csv file is found" do
    subject { Nyudl::Text::Filename.new('flubba_bubba_EOC.csv', 'mss092_ref14') }

    it { should be_recognized }
    it { should_not be_rename }
  end

  context "when <SOMETHING>_eoc.csv file is found" do
    subject { Nyudl::Text::Filename.new('flubba_bubba_eoc.csv', 'mss092_ref14') }

    it { should be_recognized }
    it { should_not be_rename }
  end


  # this is because, for some reason, Ruby can correctly convert numbers 0-7
  # to_i if they have a leading zero, but hit 08 and all bets are off.
  # probably b/c 00 -> 07 Octal are valid, but 08 is not valid Octal and
  # would be written 010.  Need to implement fix to strip leading zeros...
  # http://www.ruby-forum.com/topic/62141
  context "when using a FAILING regression-test filename" do
    subject { Nyudl::Text::Filename.new('woj_ref22_000078_08_d.tif', 'woj_ref22') }

    it { should be_recognized }
    its(:newname) { should == 'woj_ref22_n000078_z08_d.tif'}
  end

  context "when using a FAILING regression-test filename" do
    subject { Nyudl::Text::Filename.new('woj_ref22_000058_08_08_d.tif', 'woj_ref22') }

    it { should be_recognized }
    its(:newname) { should == 'woj_ref22_n000058_z08_z08_d.tif'}
  end


  # add test for 3 digit insert and oversize
  # should not be recognized, then when tested with increased max digits should be OK

  context "when using insert with 3 digits in input filename" do
    subject { Nyudl::Text::Filename.new('mss092_ref14-fr01_999d.tif', 'mss092_ref14') }

    it { should_not be_recognized }
  end

  context "when using insert with 3 digits in input filename and larger max digits and output digits" do
    subject { Nyudl::Text::Filename.new('mss092_ref14-fr01_999d.tif', 'mss092_ref14', :in_digits_max => 3, :in_digits_out => 4) }

    it { should be_recognized }
    it { should be_rename }
    its(:newname) { should == 'mss092_ref14_afr01_z0999_d.tif'}
  end



  prefix = 'mss092_ref14'
  {
    "mss092_ref14_000068m.tif"  => "mss092_ref14_n000068_m.tif",
    "mss092_ref14_000068o.tif" => "mss092_ref14_n000068_o.tif",
    "mss092_ref14_000068d.tif"  => "mss092_ref14_n000068_d.tif",
    "mss092_ref14_000068de.tif" => "mss092_ref14_n000068_de.tif",
    "mss092_ref14-fr01d.tif"    => "mss092_ref14_afr01_d.tif",
    "mss092_ref14_fr01d.tif"    => "mss092_ref14_afr01_d.tif",
    "mss092_ref14-fr01de.tif"   => "mss092_ref14_afr01_de.tif",
    "mss092_ref14_fr01de.tif"   => "mss092_ref14_afr01_de.tif",
    "mss092_ref14_bk01m.tif"    => "mss092_ref14_zbk01_m.tif",
    "mss092_ref14_bk01d.tif"    => "mss092_ref14_zbk01_d.tif",
    "mss092_ref14_bk01de.tif"   => "mss092_ref14_zbk01_de.tif",

    "mss092_ref14_000068_1m.tif" => "mss092_ref14_n000068_z01_m.tif",
    "mss092_ref14_000068_1o.tif" => "mss092_ref14_n000068_z01_o.tif",
    "mss092_ref14-fr01_1d.tif"   => "mss092_ref14_afr01_z01_d.tif",
    "mss092_ref14_fr01_1d.tif"   => "mss092_ref14_afr01_z01_d.tif",
    "mss092_ref14-fr01_1de.tif"  => "mss092_ref14_afr01_z01_de.tif",
    "mss092_ref14_fr01_1de.tif"  => "mss092_ref14_afr01_z01_de.tif",
    "mss092_ref14_bk01_1m.tif"   => "mss092_ref14_zbk01_z01_m.tif",
    "mss092_ref14_bk01_1o.tif"   => "mss092_ref14_zbk01_z01_o.tif",

    "mss092_ref14_000068_1_1m.tif"  => "mss092_ref14_n000068_z01_z01_m.tif",
    "mss092_ref14_000068_1_1o.tif"  => "mss092_ref14_n000068_z01_z01_o.tif",
    "mss092_ref14_000068_1_1d.tif"  => "mss092_ref14_n000068_z01_z01_d.tif",
    "mss092_ref14_000068_1_1de.tif" => "mss092_ref14_n000068_z01_z01_de.tif",
    "mss092_ref14-fr01_1_01d.tif"   => "mss092_ref14_afr01_z01_z01_d.tif",
    "mss092_ref14_fr01_1_01d.tif"   => "mss092_ref14_afr01_z01_z01_d.tif",
    "mss092_ref14-fr01_1_01de.tif"  => "mss092_ref14_afr01_z01_z01_de.tif",
    "mss092_ref14_fr01_1_01de.tif"  => "mss092_ref14_afr01_z01_z01_de.tif",
    "mss092_ref14_bk01_1_1m.tif"    => "mss092_ref14_zbk01_z01_z01_m.tif",
    "mss092_ref14_bk01_1_1o.tif"    => "mss092_ref14_zbk01_z01_z01_o.tif",
    "mss092_ref14_bk01_1_1d.tif"    => "mss092_ref14_zbk01_z01_z01_d.tif",
    "mss092_ref14_bk01_1_1de.tif"    => "mss092_ref14_zbk01_z01_z01_de.tif",

    "mss092_ref14_targetm.tif"      => "mss092_ref14_ztarget_m.tif",
    "mss092_ref14_target.tif"       => "mss092_ref14_ztarget_m.tif",

    "mss092_ref14_n000068_m.tif"  => "mss092_ref14_n000068_m.tif",
    "mss092_ref14_n000068_o.tif"  => "mss092_ref14_n000068_o.tif",
    "mss092_ref14_n000068_d.tif"  => "mss092_ref14_n000068_d.tif",
    "mss092_ref14_n000068_de.tif" => "mss092_ref14_n000068_de.tif",
    "mss092_ref14_afr01_d.tif"    => "mss092_ref14_afr01_d.tif",
    "mss092_ref14_afr01_de.tif"   => "mss092_ref14_afr01_de.tif",
    "mss092_ref14_zbk01_m.tif"    => "mss092_ref14_zbk01_m.tif",
    "mss092_ref14_zbk01_o.tif"    => "mss092_ref14_zbk01_o.tif",
    "mss092_ref14_zbk01_d.tif"    => "mss092_ref14_zbk01_d.tif",
    "mss092_ref14_zbk01_de.tif"   => "mss092_ref14_zbk01_de.tif",

    "mss092_ref14_n000068_m.dng"  => "mss092_ref14_n000068_m.dng",
    "mss092_ref14_zbk01_m.dng"    => "mss092_ref14_zbk01_m.dng",

    "mss092_ref14_n000068_z08_m.tif"  => "mss092_ref14_n000068_z08_m.tif",
    "mss092_ref14_n000068_z08_o.tif"  => "mss092_ref14_n000068_z08_o.tif",
    "mss092_ref14_n000068_z08_d.tif"  => "mss092_ref14_n000068_z08_d.tif",
    "mss092_ref14_n000068_z08_de.tif" => "mss092_ref14_n000068_z08_de.tif",
    "mss092_ref14_zbk01_z08_m.tif"    => "mss092_ref14_zbk01_z08_m.tif",
    "mss092_ref14_afr01_z08_d.tif"    => "mss092_ref14_afr01_z08_d.tif",
    "mss092_ref14_afr01_z08_de.tif"   => "mss092_ref14_afr01_z08_de.tif",

    "mss092_ref14_n000068_z08_z08_m.tif" => "mss092_ref14_n000068_z08_z08_m.tif",
    "mss092_ref14_n000068_z08_z08_o.tif" => "mss092_ref14_n000068_z08_z08_o.tif",
    "mss092_ref14_afr01_z08_z08_d.tif"   => "mss092_ref14_afr01_z08_z08_d.tif",
    "mss092_ref14_afr01_z08_z08_de.tif"  => "mss092_ref14_afr01_z08_z08_de.tif",
    "mss092_ref14_zbk01_z08_z08_m.tif"   => "mss092_ref14_zbk01_z08_z08_m.tif",
    "mss092_ref14_zbk01_z08_z08_o.tif"   => "mss092_ref14_zbk01_z08_z08_o.tif"
  }.each_pair do |k,v|
    context "when using known filename patterns" do
      subject(:fname) { Nyudl::Text::Filename.new(k, prefix) }
      it { should be_recognized }
      its(:newname) { should == v }
    end
  end


  describe "#role" do
    context "when a README.txt file is instantiated" do
      subject { Nyudl::Text::Filename.new('README.txt', 'mss092_ref14') }
      its(:role) { should == 'readme' }
    end

    context "when an EOC file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_eoc.csv', 'mss092_ref14') }
      its(:role) { should == 'eoc' }
    end

    context "when an xls EOC file is instantiated" do
      subject { Nyudl::Text::Filename.new('20121219-digital-ark-sta3-EOC.xls', 'mss092_ref14') }
      its(:role) { should == 'eoc' }
    end

    context "when a numbered-page master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_000068m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end

    context "when a numbered-page dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_000068d.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker' }
    end

    context "when a numbered-page enhanced dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_000068de.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker_enhanced' }
    end

    context "when a front-matter master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14-fr02m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end

    context "when a front-matter dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14-fr02d.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker' }
    end

    context "when a front-matter enhanced dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14-fr02de.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker_enhanced' }
    end

    context "when a back-matter master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_bk02m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end

    context "when a back-matter dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_bk02d.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker' }
    end

    context "when a back-matter enhanced dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_bk02de.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker_enhanced' }
    end

    context "when a target file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_target.tif', 'mss092_ref14') }
      its(:role) { should == 'target' }
    end

    context "when a numbered-page-insert master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_000068_1m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end

    context "when a front-matter-insert-with-hyphen master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14-fr01_1m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end

    context "when a front-matter-insert-with-underscore master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_fr01_1m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end

    context "when a back-matter-insert-with-underscore master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_bk01_1m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end



    context "when a numbered-page-oversized master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_000068_1_1m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end

    context "when a front-matter-oversized-with-hyphen dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14-fr01_1_01d.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker' }
    end

    context "when a front-matter-oversized-with-underscore dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_fr01_1_01d.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker' }
    end

    context "when a front-matter-oversized-with-hyphen enhanced dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14-fr01_1_01de.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker_enhanced' }
    end

    context "when a front-matter-oversized-with-underscore enhanced dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_fr01_1_01de.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker_enhanced' }
    end

    context "when a back-matter-oversized-with-underscore master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_bk01_1_1m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end


    context "when a correct numbered-page filename master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_n000068_m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end

    context "when a correct front-matter filename dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_afr01_d.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker' }
    end

    context "when a correct front-matter filename enhanced dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_afr01_de.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker_enhanced' }
    end

    context "when a correct back-matter filename master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_zbk01_m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end


    context "when a correct numbered-page-insert filename master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_n000068_z08_m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end

    context "when a correct front-matter-page-insert filename master file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_afr01_z08_m.tif', 'mss092_ref14') }
      its(:role) { should == 'master' }
    end

    context "when a correct back-matter filename dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_zbk01_z08_d.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker' }
    end

    context "when a correct back-matter filename dmaker file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_zbk01_z08_de.tif', 'mss092_ref14') }
      its(:role) { should == 'dmaker_enhanced' }
    end

    context "when a correct target file is instantiated" do
      subject { Nyudl::Text::Filename.new('mss092_ref14_ztarget_m.tif', 'mss092_ref14') }
      its(:role) { should == 'target' }
    end

  end
end
