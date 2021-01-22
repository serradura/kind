# frozen_string_literal: true

module Kind
  module Array
    extend self, CheckerMethods

    def __kind__; ::Array; end
  end

  def self.Array?(*values)
    CheckerUtils.kind_of?(::Array, values)
  end
end
