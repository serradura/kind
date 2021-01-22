# frozen_string_literal: true

module Kind
  module Method
    extend self, CheckerMethods

    def __kind__; ::Method; end
  end

  def self.Method?(*values)
    CheckerUtils.kind_of?(::Method, values)
  end
end
