module Nyudl
  module Text

    # TODO: This needs SERIOUS refactoring
    class Filename
      attr_reader :prefix, :fname, :newname, :role

      def initialize(fname, prefix, options = {})

        raise "filename must not be a path" if fname != File.basename(fname)
        @prefix  = prefix.dup
        @fname   = fname.dup
        @newname = ''
        @recognized = true
        @new_prefix = options[:new_prefix] ? options[:new_prefix] : @prefix
        @role = nil


        # initialize number fragment detectors/formatters
        @pg_num = PageNumber.new(options)
        @fr_num = FrontMatterNumber.new(options)
        @bk_num = BackMatterNumber.new(options)
        @in_num = InsertNumber.new(options)


        # the giant case statement that detects and corrects known filename formats
        case @fname
        when /\AREADME.txt\z/
          # noop
          @newname = @fname
          @role = 'readme'

        when /\A#{@prefix}_eoc.csv\z/
          # noop
          @newname = @fname
          @role = 'eoc'

          # STANDARD PAGES
        when /\A(#{@prefix})_(#{@pg_num.acc_rf})_?((d|m)\.tif)\z/   then
          # numbered page, dmaker, old-style role
          # mss092_ref27_000001d.tif -> mss092_ref27_n000001_d.tif
          # mss092_ref27_001d.tif    -> mss092_ref27_n000001_d.tif
          pn       = $2.dup
          suffix   = $3.dup
          @newname = "#{@new_prefix}_#{@pg_num.fmt(pn)}_#{suffix}"
          @role    = determine_role($4)

        when /\A(#{@prefix})(_|-)(#{@fr_num.acc_rf})_?((d|m)\.tif)\z/ then
          # front matter, dmaker, old-style role
          # mss092_ref27-fr02d.tif -> mss092_ref27_afr02_d.tif
          fr     = $3.dup
          suffix = $4.dup
          @newname = "#{@new_prefix}_#{@fr_num.fmt(fr)}_#{suffix}"
          @role    = determine_role($5)

        when /\A(#{@prefix})_(#{@bk_num.acc_rf})_?((d|m)\.tif)\z/ then
          # back matter, dmaker, old-style role
          # mss092_ref27_bk02d.tif -> mss092_ref27_zbk02_d.tif
          bk     = $2.dup
          suffix = $3.dup
          @newname = "#{@new_prefix}_#{@bk_num.fmt(bk)}_#{suffix}"
          @role    = determine_role($4)

        when /\A(#{@prefix})_target_?m?(\.tif)\z/   then
          @newname = "#{@new_prefix}_ztarget_m#{$2}"
          @role    = 'target'


          # INSERTS (accepts and corrects _N or _NN)
        when /\A(#{@prefix})_(#{@pg_num.acc_rf})_(#{@in_num.acc_rf})_?((d|m)\.tif)\z/   then
          # numbered page, old-style role
          pn     = $2.dup
          inum   = $3.dup
          suffix = $4.dup
          @newname = "#{@new_prefix}_#{@pg_num.fmt(pn)}_#{@in_num.fmt(inum)}_#{suffix}"
#          @role    = determine_role($5)

        when /\A(#{@prefix})(-|_)(#{@fr_num.acc_rf})_(#{@in_num.acc_rf})_?((d|m)\.tif)\z/ then
          # front matter, old-style role
          fr      = $3.dup
          inum    = $4.dup
          suffix  = $5.dup
          @newname = "#{@new_prefix}_#{@fr_num.fmt(fr)}_#{@in_num.fmt(inum)}_#{suffix}"

        when /\A(#{@prefix})_(#{@bk_num.acc_rf})_(#{@in_num.acc_rf})_?((d|m)\.tif)\z/ then
          # back matter, old-style role
          bk     = $2.dup
          inum   = $3.dup
          suffix = $4.dup
          @newname = "#{@new_prefix}_#{@bk_num.fmt(bk)}_#{@in_num.fmt(inum)}_#{suffix}"


          # OVERSIZED (accepts and corrects _N or _NN)
        when /\A(#{@prefix})_(#{@pg_num.acc_rf})_(\d+)_(\d+)_?((d|m)\.tif)\z/   then
          # numbered page, old-style role
          pn       = $2.dup
          olevel_1 = $3.dup
          olevel_2 = $4.dup
          suffix   = $5.dup
          @newname = "#{@new_prefix}_#{@pg_num.fmt(pn)}_z#{'%02d' % olevel_1.gsub(/\A0+/, '')}_z#{'%02d' % olevel_2.gsub(/\A0+/, '')}_#{suffix}"

        when /\A(#{@prefix})(-|_)(#{@fr_num.acc_rf})_(\d+)_(\d+)_?((d|m)\.tif)\z/ then
          # front matter, old-style role
          fr       = $3.dup
          olevel_1 = $4.dup
          olevel_2 = $5.dup
          suffix   = $6.dup
          @newname = "#{@new_prefix}_#{@fr_num.fmt(fr)}_z#{'%02d' % olevel_1.gsub(/\A0+/, '')}_z#{'%02d' % olevel_2.gsub(/\A0+/, '')}_#{suffix}"

        when /\A(#{@prefix})_(#{@bk_num.acc_rf})_(\d+)_(\d+)_?((d|m)\.tif)\z/ then
          # back matter, old-style role
          bk       = $2.dup
          olevel_1 = $3.dup
          olevel_2 = $4.dup
          suffix   = $5.dup
          @newname = "#{@new_prefix}_#{@bk_num.fmt(bk)}_z#{'%02d' % olevel_1.gsub(/\A0+/, '')}_z#{'%02d' % olevel_2.gsub(/\A0+/, '')}_#{suffix}"


          # Replace prefix if new_prefix provided
          # using #out_rf because this section is for files that do not need correction
          # other than possible prefix replacement
        when /\A(#{@prefix})(_#{@pg_num.out_rf}_(m|d)\.tif)/ ,
          /\A(#{@prefix})(_#{@fr_num.out_rf}_(m|d)\.tif)/ ,
          /\A(#{@prefix})(_#{@bk_num.out_rf}_(m|d)\.tif)/ ,

          /\A(#{@prefix})(_#{@pg_num.out_rf}_#{@in_num.out_rf}_(m|d)\.tif)/ ,
          /\A(#{@prefix})(_#{@fr_num.out_rf}_#{@in_num.out_rf}_(m|d)\.tif)/ ,
          /\A(#{@prefix})(_#{@bk_num.out_rf}_#{@in_num.out_rf}_(m|d)\.tif)/ ,

          /\A(#{@prefix})(_#{@pg_num.out_rf}_z\d{2}_z\d{2}_(m|d)\.tif)/ ,
          /\A(#{@prefix})(_#{@fr_num.out_rf}_z\d{2}_z\d{2}_(m|d)\.tif)/ ,
          /\A(#{@prefix})(_#{@bk_num.out_rf}_z\d{2}_z\d{2}_(m|d)\.tif)/ ,
          /\A(#{@prefix})(_ztarget_m.tif)/
        then @newname = "#{@new_prefix}#{$2}"

        else
          @recognized = false
        end
      end

      def recognized?
        @recognized
      end

      def rename?
        # rename only valid if file was recognized
        if self.recognized?
          @fname != @newname
        else
          nil
        end
      end

      private
      def determine_role(str)
        case str
          when 'd' then 'dmaker'
          when 'm' then 'master'
        end
      end
    end
  end
end
