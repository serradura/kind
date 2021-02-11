# frozen_string_literal: true

module Kind
  module Numeric
    extend self, TypeChecker

    def kind; ::Numeric; end
  end

  def self.Numeric?(*values)
    KIND.of?(::Numeric, values)
  end
end
