module Nyudl
  module Text
    class PageNumber
      attr_reader :acc_rf, :out_rf  # accept regex fragment, output regex fragment

      def initialize(options = {})
        @acc_rf = '\d{3,6}'
        @out_rf = 'n\d{6}'
      end

      def fmt(str)
        'n' + '%06d' % str.gsub(/\A0+/, '')
      end
    end
  end
end
