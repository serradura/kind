# frozen_string_literal: true

module Kind
  module String
    extend self, TypeChecker

    def kind; ::String; end

    def value_or_empty(arg)
      __value(arg, Empty::STRING)
    end
  end

  def self.String?(*values)
    KIND.of?(::String, values)
  end
end
