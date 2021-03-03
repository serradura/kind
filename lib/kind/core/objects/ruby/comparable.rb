# frozen_string_literal: true

module Kind
  module Comparable
    extend self, ::Kind::Object

    def kind; ::Comparable; end
  end

  def self.Comparable?(*values)
    KIND.of?(::Comparable, values)
  end
end
