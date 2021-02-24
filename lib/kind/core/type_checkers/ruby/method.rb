# frozen_string_literal: true

module Kind
  module Method
    extend self, TypeChecker

    def kind; ::Method; end
  end

  def self.Method?(*values)
    KIND.of?(::Method, values)
  end
end
