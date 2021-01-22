# frozen_string_literal: true

module Kind
  module Symbol
    extend self, CheckerMethods

    def __kind__; ::Symbol; end
  end

  def self.Symbol?(*values)
    CheckerUtils.kind_of?(::Symbol, values)
  end
end
