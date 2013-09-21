module Nyudl
  module Text
    class FrontMatterNumber
      attr_reader :acc_rf, :out_rf  # accept regex fragment, output regex fragment

      FR_DIGITS_DEFAULT = 2

      def initialize(options = {})
        @fr_digits_max = options[:fr_digits_max] ? options[:fr_digits_max] : FR_DIGITS_DEFAULT
        @fr_digits_out     = options[:fr_digits_out] ? options[:fr_digits_out] : FR_DIGITS_DEFAULT
        @acc_rf = "fr\\d{#{FR_DIGITS_DEFAULT},#{@fr_digits_max}}"
        @out_rf = "afr\\d{#{@fr_digits_out}}"

        raise "invalid parameters: fr_digits_max > fr_digits_out" if @fr_digits_max > @fr_digits_out
      end

      def fmt(str)
        md = /\Aa?fr(?<fr_num>\d+)\z/.match(str)
        raise "unable to extract front matter number" if md.nil?
        'afr' + "%0#{@fr_digits_out}d" % md[:fr_num].gsub(/\A0+/, '')
      end
    end
  end
end
