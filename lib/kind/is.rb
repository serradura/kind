# frozen_string_literal: true

module Kind
  module Is
    def self.call(expected, value)
      expected_mod = Kind::Of.Module(expected)
      mod = Kind::Of.Module(value)

      mod <= expected_mod || false
    end

    def self.Class(value)
      value.is_a?(::Class)
    end

    def self.Module(value)
      value == ::Module || (value.is_a?(::Module) && !self.Class(value))
    end
  end
end
