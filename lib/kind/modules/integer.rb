# frozen_string_literal: true

module Kind
  module Integer
    extend self, CheckerMethods

    def __kind__; ::Integer; end
  end

  def self.Integer?(*values)
    CheckerUtils.kind_of?(::Integer, values)
  end
end
