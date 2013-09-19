require 'spec_helper'

describe Text::StateMachine do
  describe "start state transitions" do
    let(:sm) { Text::StateMachine.new }

    it "is in the correct state for context" do
      sm.should be_start
    end

    it "accepts transition to fm" do
      sm.found_fm.should be_true
      sm.should be_fm
    end

    it "accepts transition to np" do
      sm.found_np.should be_true
      sm.should be_np
    end

    it "rejects transition to bm" do
      expect { sm.found_bm }.to raise_error(AASM::InvalidTransition)
    end

    it "accepts transition to in" do
      sm.found_in.should be_true
      sm.should be_in
    end

    it "accepts transition to ov" do
      sm.found_ov.should be_true
      sm.should be_ov
    end

    it "reject transition to end" do
      expect { sm.found_end }.to raise_error(AASM::InvalidTransition)
    end
  end

  describe "fm state transitions" do
    let(:sm) { a = Text::StateMachine.new ; a.found_fm ; a }

    it "is in the correct state for context" do
      sm.should be_fm
    end

    it "accepts transition to fm" do
      sm.found_fm.should be_true
      sm.should be_fm
    end

    it "accepts transition to np" do
      sm.found_np.should be_true
      sm.should be_np
    end

    it "accepts transition to bm" do
      sm.found_bm.should be_true
      sm.should be_bm
    end

    it "accepts transition to in" do
      sm.found_in.should be_true
      sm.should be_in
    end

    it "accepts transition to ov" do
      sm.found_ov.should be_true
      sm.should be_ov
    end

    it "accepts transition to end" do
      sm.found_end.should be_true
      sm.should be_end
    end
  end

  describe "np state transitions" do
    let(:sm) { a = Text::StateMachine.new ; a.found_np ; a }

    it "is in the correct state for context" do
      sm.should be_np
    end

    it "rejects transition to fm" do
      expect { sm.found_fm }.to raise_error(AASM::InvalidTransition)
    end

    it "accepts transition to np" do
      sm.found_np.should be_true
      sm.should be_np
    end

    it "accepts transition to bm" do
      sm.found_bm.should be_true
      sm.should be_bm
    end

    it "accepts transition to in" do
      sm.found_in.should be_true
      sm.should be_in
    end

    it "accepts transition to ov" do
      sm.found_ov.should be_true
      sm.should be_ov
    end

    it "accepts transition to end" do
      sm.found_end.should be_true
      sm.should be_end
    end
  end

  describe "bm state transitions" do
    let(:sm) { a = Text::StateMachine.new ; a.found_np ; a.found_bm; a }

    it "is in the correct state for context" do
      sm.should be_bm
    end

    it "rejects transition to fm" do
      expect { sm.found_fm }.to raise_error(AASM::InvalidTransition)
    end

    it "rejects transition to np" do
      expect { sm.found_np }.to raise_error(AASM::InvalidTransition)
    end

    it "accepts transition to bm" do
      sm.found_bm.should be_true
      sm.should be_bm
    end

    it "accepts transition to in" do
      sm.found_in.should be_true
      sm.should be_in
    end

    it "accepts transition to ov" do
      sm.found_ov.should be_true
      sm.should be_ov
    end

    it "accepts transition to end" do
      sm.found_end.should be_true
      sm.should be_end
    end
  end

  describe "in state transitions" do
    let(:sm) { a = Text::StateMachine.new ; a.found_in ; a }

    it "is in the correct state for context" do
      sm.should be_in
    end

    it "accepts transition to fm" do
      sm.found_fm.should be_true
      sm.should be_fm
    end

    it "accepts transition to np" do
      sm.found_np.should be_true
      sm.should be_np
    end

    it "accepts transition to bm" do
      sm.found_bm.should be_true
      sm.should be_bm
    end

    it "accepts transition to in" do
      sm.found_in.should be_true
      sm.should be_in
    end

    it "accepts transition to ov" do
      sm.found_ov.should be_true
      sm.should be_ov
    end

    it "accepts transition to end" do
      sm.found_end.should be_true
      sm.should be_end
    end
  end

  describe "ov state transitions" do
    let(:sm) { a = Text::StateMachine.new ; a.found_ov ; a }

    it "is in the correct state for context" do
      sm.should be_ov
    end

    it "accepts transition to fm" do
      sm.found_fm.should be_true
      sm.should be_fm
    end

    it "accepts transition to np" do
      sm.found_np.should be_true
      sm.should be_np
    end

    it "accepts transition to bm" do
      sm.found_bm.should be_true
      sm.should be_bm
    end

    it "accepts transition to in" do
      sm.found_in.should be_true
      sm.should be_in
    end

    it "accepts transition to ov" do
      sm.found_ov.should be_true
      sm.should be_ov
    end

    it "accepts transition to end" do
      sm.found_end.should be_true
      sm.should be_end
    end
  end

  describe "in state transitions" do
    let(:sm) { a = Text::StateMachine.new ; a.found_np; a.found_end ; a }

    it "is in the correct state for context" do
      sm.should be_end
    end

    it "rejects transition to fm" do
      expect { sm.found_fm }.to raise_error(AASM::InvalidTransition)
    end

    it "rejects transition to np" do
      expect { sm.found_np }.to raise_error(AASM::InvalidTransition)
    end

    it "rejects transition to bm" do
      expect { sm.found_bm }.to raise_error(AASM::InvalidTransition)
    end

    it "rejects transition to in" do
      expect { sm.found_in }.to raise_error(AASM::InvalidTransition)
    end

    it "rejects transition to ov" do
      expect { sm.found_ov }.to raise_error(AASM::InvalidTransition)
    end

    it "rejects transition to end" do
      expect { sm.found_end }.to raise_error(AASM::InvalidTransition)
    end
  end


end

=begin
  let(:sm) { Text::StateMachine.new }

#  before(:each) do
#    @sm = Text::StateMachine.new
#  end

  it "#class is correct" do
    sm.class.should == Text::StateMachine 
  end

  it "should initialize in the start state" do
    expect(sm.start?).to be_true
  end

  it "should allow transition from start to front matter" do
    expect(sm.found_fm).to be_true
    expect(sm.fm?).to be_true
  end

 # it "should throw and exception when transitioning from start to end" do
 #   expect(@sm.found_end).exception.to == 
 #   expect(@sm.end?).to be_true
 # end


end
=end
