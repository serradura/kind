# frozen_string_literal: true

module Kind
  module Range
    extend self, CheckerMethods

    def __kind__; ::Range; end
  end

  def self.Range?(*values)
    CheckerUtils.kind_of?(::Range, values)
  end
end
