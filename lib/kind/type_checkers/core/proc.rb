# frozen_string_literal: true

module Kind
  module Proc
    extend self, TypeChecker

    def kind; ::Proc; end
  end

  def self.Proc?(*values)
    KIND.of?(::Proc, values)
  end
end
