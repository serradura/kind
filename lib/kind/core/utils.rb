# frozen_string_literal: true

module Kind
  module Core::Utils
    def self.kind(of:, by:)
      of.empty? ? by : of.all?(&by)
    end

    def self.kind_of?(kind, values)
      kind(of: values, by: -> value {
        value.kind_of?(kind)
      })
    end

    def self.kind_of!(kind, object, kind_name = nil)
      return object if kind === object

      raise Kind::Error.new(kind_name || kind.name, object)
    end

    def self.is?(expected, value)
      is_kind(Kind::Module[expected], value)
    end

    def self.is_kind(expected_kind, value)
      kind = Kind::Module[value]

      if kind.kind_of?(::Class)
        kind <= expected_kind || false
      else
        kind == expected_kind || kind.kind_of?(expected_kind)
      end
    end
  end
end
