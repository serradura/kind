# frozen_string_literal: true

module Kind
  module Enumerable
    extend self, CheckerMethods

    def __kind__; ::Enumerable; end
  end

  def self.Enumerable?(*values)
    CheckerUtils.kind_of?(::Enumerable, values)
  end
end
