# frozen_string_literal: true

module Kind
  module Enum
    class Item
      Underscore = ->(arg) do
        str = String(arg).strip
        str.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        str.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        str.tr!("-", "_")
        str.downcase!
        str
      end

      attr_reader :value, :to_s, :name, :to_sym, :inspect

      alias_method :key, :to_s
      alias_method :to_str, :to_s

      def initialize(key, val)
        @value = val.frozen? ? val : val.dup.freeze

        @to_s = Kind.respond_to(key, :to_sym).to_s
        @name = Underscore[key].upcase.freeze
        @to_sym = key.to_sym
        @inspect = ('#<Kind::Enum::Item name=%p to_s=%p value=%p>' % [@name, @to_s, @value]).freeze
      end

      def ==(arg)
        arg == value || arg == to_s || arg == to_sym
      end

      def to_ary
        [key, value]
      end

      alias_method :===, :==
    end
  end
end
