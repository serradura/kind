# frozen_string_literal: true

module Kind
  module Enumerator
    extend self, CheckerMethods

    def __kind__; ::Enumerator; end
  end

  def self.Enumerator?(*values)
    CheckerUtils.kind_of?(::Enumerator, values)
  end
end
