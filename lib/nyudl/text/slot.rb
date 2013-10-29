# a text slot has the following attributes
# location: right, left, top, bottom
# type: page, insert, unnumbered, page_alt, page_missing, page_defective, oversized
#
# sequence checker for texts
module Nyudl
  module Text
    class Slot
      TYPES = %w(page insert unnumbered page_alt page_missing page_defective oversized)
      LOCATIONS = %w(right left top bottom)

      def initialize(params, options = {})
        @type     = params[:type]
        @location = params[:location]
        @files    = params[:files]
        @errors   = Nyudl::Text::Errors.new

        validate_location
        validate_type
        raise ArgumentError.new("errors found") unless @errors.empty?
      end

      def errors(key = nil)
        key.nil? ? @errors.all : @errors.on(key)
      end

      private
      def validate_location
        @errors.add(:location, "invalid location: @location") unless LOCATIONS.include?(@location)
      end
      def validate_type
        @errors.add(:type, "invalid type: @type") unless TYPES.include?(@type)
      end
    end
  end
end
