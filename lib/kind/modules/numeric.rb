# frozen_string_literal: true

module Kind
  module Numeric
    extend self, CheckerMethods

    def __kind__; ::Numeric; end
  end

  def self.Numeric?(*values)
    CheckerUtils.kind_of?(::Numeric, values)
  end
end
