# sequence checker for texts
require 'aasm'

module Text
  class StateMachine
    include AASM

    aasm do
      state :start, :initial => true
      state :fm    # front matter
      state :np    # numbered page
      state :bm    # back matter
      state :in    # insert
      state :ov    # oversized
      state :end

      event :found_fm  do
        transitions :from => [:start, :fm,           :in, :ov], :to => :fm
      end
      event :found_np  do
        transitions :from => [:start, :fm, :np,      :in, :ov], :to => :np
      end
      event :found_bm  do
        transitions :from => [        :fm, :np, :bm, :in, :ov], :to => :bm
      end
      event :found_in  do
        transitions :from => [:start, :fm, :np, :bm, :in, :ov], :to => :in
      end
      event :found_ov  do
        transitions :from => [:start, :fm, :np, :bm, :in, :ov], :to => :ov
      end
      event :found_end do
        transitions :from => [        :fm, :np, :bm, :in, :ov], :to => :end
      end
    end
  end
end
