# frozen_string_literal: true

module Kind
  module String
    extend self, ::Kind::Object

    def kind; ::String; end

    def value_or_empty(arg)
      KIND.value(self, arg, Empty::STRING)
    end
  end

  def self.String?(*values)
    KIND.of?(::String, values)
  end
end
