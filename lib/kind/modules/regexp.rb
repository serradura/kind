# frozen_string_literal: true

module Kind
  module Regexp
    extend self, CheckerMethods

    def __kind__; ::Regexp; end
  end

  def self.Regexp?(*values)
    CheckerUtils.kind_of?(::Regexp, values)
  end
end
