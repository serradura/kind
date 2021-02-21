# frozen_string_literal: true

module Kind
  module Regexp
    extend self, TypeChecker

    def kind; ::Regexp; end
  end

  def self.Regexp?(*values)
    KIND.of?(::Regexp, values)
  end
end
