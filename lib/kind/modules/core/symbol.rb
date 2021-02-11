# frozen_string_literal: true

module Kind
  module Symbol
    extend self, TypeChecker

    def kind; ::Symbol; end
  end

  def self.Symbol?(*values)
    KIND.of?(::Symbol, values)
  end
end
