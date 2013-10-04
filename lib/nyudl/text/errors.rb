module Nyudl
  module Text
    class Errors
      def initialize()
        @errors = {}
      end
      def add(key, message)
        k = convert_key(key)
        @errors[k] = [] if @errors[k].nil?
        @errors[k] << message
      end
      def on(key)
        @errors[convert_key(key)]
      end
      def all
        @errors
      end
      def empty?
        @errors.values.inject(true) {|memo, value| memo && value.empty?}
      end
      private
      def convert_key(key)
        key.class == Symbol ? key : key.to_sym
      end
    end
  end
end
