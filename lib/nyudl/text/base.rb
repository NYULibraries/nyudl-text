require 'fileutils'

module Nyudl
  module Text
    # Public: Class to validate and rename NYU DLTS Text objects.
    #         A text contains pages of various types, e.g., front matter,
    #         numbered pages, back matter, and inserts. There are also
    #         ancillary files that are acceptable, e.g., the target file,
    #         environment of creation data, README files.
    class Base

      # Public: This is the constructor for the class.
      #
      # dir     - The String containing the directory path for the text
      # prefix  - The String containing the prefix for the text, this is
      #           typically the digital object name, e.g., nyu_aco123456
      # options - The Hash options used to refine object behavior (default: {}).
      #           :verbose       - The Boolean that determines whether or not
      #                            to output additional text during processing.
      #           :noop          - The Boolean that determines whether or not
      #                            to actually rename files.
      #           :new_prefix    - The String containing the new prefix to
      #                            use for the filenames. For example, if
      #                            prefix == nyu_aco123456 and the :new_prefix
      #                            value is nyu_aco423111, then upon a rename!
      #                            operation, all content file names will start
      #                            with nyu_aco423111.
      #           :fr_digits_max - The Integer value for the maximum number of
      #                            acceptable digits for all front matter pages.
      #                            Front matter pages may have fewer than the
      #                            fr_digits_max digits and still be recognized.
      #           :fr_digits_out - The Integer number of zero-padded digits that
      #                            will be output for all front matter pages.
      #           :bk_digits_max - The Integer value for the maximum number of
      #                            acceptable digits for all back matter pages.
      #                            Back matter pages may have fewer than the
      #                            bk_digits_max digits and still be recognized.
      #           :bk_digits_out - The Integer number of zero-padded digits that
      #                            will be output for all back matter pages.
      #           :in_digits_max - The Integer value for the maximum number of
      #                            acceptable digits for all insert pages.
      #                            Insert pages may have fewer than the
      #                            in_digits_max digits and still be recognized.
      #           :in_digits_out - The Integer number of zero-padded digits that
      #                            will be output for all insert pages.
      #
      # Examples
      #
      #   Nyudl::Text::Base.new('/content/nyu_aco000001', 'nyu_aco000001')
      #   Nyudl::Text::Base.new('/content/nyu_aco000001', 'nyu_aco000001',
      #                         {:verbose => true, :noop => true})
      #   Nyudl::Text::Base.new('/content/nyu_aco000001', 'nyu_aco000001',
      #                         {:new_prefix => nyu_aco000002})
      #
      # Returns nothing.
      # Raises ArgumentError if the dir argument is not a directory or if
      #   the current process cannot list/access the files in the directory.
      def initialize(dir, prefix, options = {})
        raise ArgumentError, "#{dir} must be a directory" unless File.directory?(dir)
        raise ArgumentError, "cannot read contents of directory #{dir}" unless File.executable?(dir)

        @dir      = dir
        @prefix   = prefix
        @options  = options
#        @errors   = Nyudl::Text::Errors.new
        @errors   = nil
        # nil values indicate "undetermined state"
        @valid    = nil
        @renames  = {}
        @names    = {}
        @analyzed = false
      end

      # Public: Indicates whether or not text is valid.
      #
      # Examples
      #
      #   valid?
      #   # => true
      #
      #   valid?
      #   # => false
      #
      #   valid?
      #   # => nil
      #
      # Returns Boolean true when text passed all checks.
      # Returns Boolean false when text failed any checks.
      # Returns NilClass nil if method called before analyze
      def valid?
        # text must be have been analyzed
        # valid if no renames required and no errors
        analyzed? ? (!rename? && errors.empty?) : nil
      end


      # Public: Runs analyses on the text.
      #
      # Examples
      #
      #   analyze
      #   # => nil
      #
      # Returns nil at all times.
      def analyze
        analyze_text
        @analyzed = true
        nil
      end


      # Public: This method returns the errors Hash.
      #         The errors Hash is a Hash of Symbol keys and Array values.
      #
      # key   - The Symbol used to select a subset of the errors Hash
      #         (default: nil). When key is present, the method returns
      #         the Array of errors for that key. If key is not supplied
      #         the entire errors Hash is returned.
      #
      # Examples
      #
      #   errors
      #   # => {}       # if no errors found
      #   # => {:foo => ['foo was missing from bar'],
      #         :baz => ['baz not declared for quux']}
      #
      #   errors(:baz)
      #   # => ['baz not declared for quux']
      #
      # Returns errors Hash if key not supplied.
      # Returns Array of error Strings for key if key supplied.
      def errors(key = nil)
        key.nil? ? @errors : @errors[key]
      end
      # def errors(key)
      #   @errors.on(key)
      # end
      def rename?
        !@renames.empty?
      end
      def rename!
        execute_rename_plan
      end
      def rename_plan
        gen_rename_array
      end
      def analyzed?
        @analyzed
      end
      def recognized?
        analyzed? ? @errors[:unrecognized].empty? : nil
      end


      private

      # Internal: This method performs the text analysis and updates
      #          the associated instance variables.
      #
      # Returns nothing.
      # Raises  nothing.
      def analyze_text
        reset_analyzed
        @errors  = Hash.new { |_h, k| _h[k] = [] }
        @renames = {}
        @names   = {}

        Dir.chdir(@dir) do
          if Dir.glob('*').length == 0
            @errors[:structure] << "No files found in #{@dir}."
            return
          end
        end

        Dir.foreach(@dir) do |f|
          next if (f == '.' || f == '..')

          @errors[:structure] << "error: found a subdirectory. cannot process." if File.directory?(f)

          i = Nyudl::Text::Filename.new(f, @prefix, @options)

          @errors[:unrecognized] << "#{File.join(@dir,i.fname)}" unless i.recognized?

          # only add to hash if rename is required
          @renames[i.newname] = i if i.rename?
          @names[i.newname]   = i
        end
        set_analyzed
      end

      # def analyze_text
      #   @errors  = Hash.new { |_h, k| _h[k] = [] }
      #   @renames = {}
      #   @names   = {}

      #   Dir.chdir(@dir) do
      #     if Dir.glob('*').length == 0
      #       @errors[:structure] << "No files found in #{@dir}."
      #       return
      #     end
      #   end

      #   Dir.foreach(@dir) do |f|
      #     next if (f == '.' || f == '..')

      #     @errors[:structure] << "error: found a subdirectory. cannot process." if File.directory?(f)

      #     i = Nyudl::Text::Filename.new(f, @prefix, @options)

      #     @errors[:unrecognized] << "#{File.join(@dir,i.fname)}" unless i.recognized?

      #     # only add to hash if rename is required
      #     @renames[i.newname] = i if i.rename?
      #     @names[i.newname]   = i
      #   end
      # end

      def execute_rename_plan
        raise "Cannot rename.  Text not analyzed." unless analyzed?
        raise "Cannot rename.  Errors detected."   unless @errors.values.inject(true) {|memo, value| memo && value.empty?}
        @renames.keys.sort.each do |k|
          FileUtils.mv(File.join(@dir, @renames[k].fname),
                       File.join(@dir, @renames[k].newname),
                       :verbose => @options[:verbose], :noop => @options[:noop])
        end
        reset_analyzed
      end

      def set_analyzed
        @analyzed = true
      end

      def reset_analyzed
        @analyzed = false
      end

      def gen_rename_array
        a = []
        @renames.keys.sort.each do |k|
          a << [File.join(@dir, @renames[k].fname), File.join(@dir, @renames[k].newname)]
        end
        a
      end
    end
  end
end
