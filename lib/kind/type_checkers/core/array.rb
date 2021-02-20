# frozen_string_literal: true

module Kind
  module Array
    extend self, TypeChecker

    def kind; ::Array; end

    def value_or_empty(arg)
      __value(arg, Empty::ARRAY)
    end
  end

  def self.Array?(*values)
    KIND.of?(::Array, values)
  end
end
