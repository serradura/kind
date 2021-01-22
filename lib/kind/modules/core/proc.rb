# frozen_string_literal: true

module Kind
  module Proc
    extend self, CheckerMethods

    def __kind__; ::Proc; end
  end

  def self.Proc?(*values)
    CheckerUtils.kind_of?(::Proc, values)
  end
end
