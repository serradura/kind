# frozen_string_literal: true

module Kind
  module Regexp
    extend self, ::Kind::Object

    def kind; ::Regexp; end
  end

  def self.Regexp?(*values)
    KIND.of?(::Regexp, values)
  end
end
