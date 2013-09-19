module Text
  class BackMatterNumber
    attr_reader :acc_rf, :out_rf  # accept regex fragment, output regex fragment

    BK_DIGITS_DEFAULT = 2

    def initialize(options = {})
      @bk_digits_max = options[:bk_digits_max] ? options[:bk_digits_max] : BK_DIGITS_DEFAULT
      @bk_digits_out = options[:bk_digits_out] ? options[:bk_digits_out] : BK_DIGITS_DEFAULT
      @acc_rf = "bk\\d{#{BK_DIGITS_DEFAULT},#{@bk_digits_max}}"
      @out_rf = "zbk\\d{#{@bk_digits_out}}"

      raise "invalid parameters: bk_digits_max > bk_digits_out" if @bk_digits_max > @bk_digits_out
    end

    def fmt(str)
      md = /\Az?bk(?<bk_num>\d+)\z/.match(str)
      raise "unable to extract back matter number" if md.nil?
      'zbk' + "%0#{@bk_digits_out}d" % md[:bk_num].gsub(/\A0+/, '')
    end
  end
end
