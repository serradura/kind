# frozen_string_literal: true

module Kind
  module Method
    extend self, Core::Checker

    def kind; ::Method; end
  end

  def self.Method?(*values)
    Core::Utils.kind_of?(::Method, values)
  end
end
