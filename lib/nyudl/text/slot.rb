# README
# This class is used to detect the type of slot present in a text
# This analysis is completed by pushing NyuDl::Text::Filename objects
# into the object until the slot type is recognized or reaches an
# impossible state.
#
# STATES:
# d file with matching m file
# d file with multiple m files with unnumbered/oversized extension
#
# CASES:
# front matter  1d:1m
# numbered page 1d:1m
# back matter   1d:1m
#
# unnumbered page 1d:1m after front matter
# unnumbered page 1d:1m after numbered page
# unnumbered page 1d:1m after back matter
#
# oversized page 1d:Nm after front matter
# oversized page 1d:Nm after numbered page
# oversized page 1d:Nm after back matter
#

# a text slot has the following attributes
# location: right, left, top, bottom
# type: page, insert, unnumbered, page_alt, page_missing, page_defective, oversized, front_matter, back_matter
#
# sequence checker for texts
#
#
# usage:
# instantiate slot object
# if parameters are known, great, if not, that's ok too
# test "recognized?"
# if not recognized?, check errors?
# if no errors,
#  << NyuDl::Text::Filename object



module Nyudl
  module Text
    class Slot
      TYPES = %w(page insert unnumbered page_alt page_missing page_defective oversized front_matter back_matter)
      LOCATIONS = %w(right left top bottom)

      attr_reader :files

      def initialize(params = {}, options = {})
        @type     = params[:type]
        @location = params[:location]
        @files    = params[:files] ? params[:files] : {}
        @errors   = Nyudl::Text::Errors.new
        @options  = options
        @recognized = false

        validate_location if @location
        validate_type     if @type
      end

      def errors(key = nil)
        key.nil? ? @errors.all : @errors.on(key)
      end

      def <<(f)
        @files[f.role] = @files[f.role] ? @files[f.role] << f : [f]
        analyze_files
      end

      def recognized?
        # if there are errors, then override @recognized attribute
        @errors.empty? ?  @recognized : false
      end

      private
      def validate_location
        @errors.add(:location, "invalid location: #{@location}") unless LOCATIONS.include?(@location)
      end
      def validate_type
        @errors.add(:type, "invalid type: #{@type}") unless TYPES.include?(@type)
      end
      def analyze_files
      end
    end
  end
end
