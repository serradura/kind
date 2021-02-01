# frozen_string_literal: true

module Kind
  module Regexp
    extend self, Core::Checker

    def kind; ::Regexp; end
  end

  def self.Regexp?(*values)
    Core::Utils.kind_of?(::Regexp, values)
  end
end
