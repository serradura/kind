# frozen_string_literal: true

module Kind
  module Proc
    extend self, Core::Checker

    def __kind__; ::Proc; end
  end

  def self.Proc?(*values)
    Core::Utils.kind_of?(::Proc, values)
  end
end
