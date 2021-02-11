# frozen_string_literal: true

module Kind
  module Array
    extend self, TypeChecker

    def kind; ::Array; end
  end

  def self.Array?(*values)
    KIND.of?(::Array, values)
  end
end
