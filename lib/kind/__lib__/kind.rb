# frozen_string_literal: true

require 'kind/__lib__/strict'

module Kind
  module KIND
    extend self

    def nil_or_undefined?(value) # :nodoc:
      value.nil? || Undefined == value
    end

    def of?(kind, values) # :nodoc:
      of_kind = -> value { kind === value }

      values.empty? ? of_kind : values.all?(&of_kind)
    end

    def respond_to!(method_name, value) # :nodoc:
      return value if value.respond_to?(method_name)

      raise Error.new("expected #{value} to respond to :#{method_name}")
    end

    def interface?(method_names, value) # :nodoc:
      method_names.all? { |method_name| value.respond_to?(method_name) }
    end

    def value(kind, arg, default) # :nodoc:
      kind === arg ? arg : default
    end

    def is?(expected, value) # :nodoc:
      is(STRICT.module_or_class(expected), value)
    end

    private

      def is(expected_kind, value) # :nodoc:
        kind = STRICT.module_or_class(value)

        if OF.class?(kind)
          kind <= expected_kind || expected_kind == ::Class
        else
          kind == expected_kind || kind.kind_of?(expected_kind)
        end
      end
  end

  private_constant :KIND
end
