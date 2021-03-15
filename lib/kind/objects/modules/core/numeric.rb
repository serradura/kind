# frozen_string_literal: true

module Kind
  module Numeric
    extend self, ::Kind::Object

    def kind; ::Numeric; end
  end

  def self.Numeric?(*values)
    KIND.of?(::Numeric, values)
  end
end
