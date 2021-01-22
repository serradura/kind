# frozen_string_literal: true

module Kind
  module Comparable
    extend self, CheckerMethods

    def __kind__; ::Comparable; end
  end

  def self.Comparable?(*values)
    CheckerUtils.kind_of?(::Comparable, values)
  end
end
