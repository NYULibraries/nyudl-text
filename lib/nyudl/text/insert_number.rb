module Text
  class InsertNumber
    attr_reader :acc_rf, :out_rf  # accept regex fragment, output regex fragment

    IN_DIGITS_MIN_DEFAULT = 1
    IN_DIGITS_MAX_DEFAULT = 2

    def initialize(options = {})
      @in_digits_max = options[:in_digits_max] ? options[:in_digits_max] : IN_DIGITS_MAX_DEFAULT
      @in_digits_out = options[:in_digits_out] ? options[:in_digits_out] : IN_DIGITS_MAX_DEFAULT
      # Accept format
      @acc_rf = "\\d{#{IN_DIGITS_MIN_DEFAULT},#{@in_digits_max}}"
      # output format
      @out_rf = "z\\d{#{@in_digits_out}}"

      raise "invalid parameters: in_digits_max > in_digits_out" if @in_digits_max > @in_digits_out
    end

    def fmt(str)
      md = /\Az?(?<in_num>\d+)\z/.match(str)
      raise "unable to extract insert number" if md.nil?
      'z' + "%0#{@in_digits_out}d" % md[:in_num].gsub(/\A0+/, '')
    end
  end
end
