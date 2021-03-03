# frozen_string_literal: true

module Kind
  module Array
    extend self, ::Kind::Object

    def kind; ::Array; end

    def value_or_empty(arg)
      KIND.value(self, arg, Empty::ARRAY)
    end
  end

  def self.Array?(*values)
    KIND.of?(::Array, values)
  end
end
