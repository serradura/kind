# frozen_string_literal: true

module Kind
  module Checker
    def class?(value)
      Kind::Is.(__kind, value)
    end

    def instance?(value)
      value.is_a?(__kind)
    end

    def or_nil(value)
      return value if instance?(value)
    end
  end

  private_constant :Checker
end
