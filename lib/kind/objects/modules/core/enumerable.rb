# frozen_string_literal: true

module Kind
  module Enumerable
    extend self, ::Kind::Object

    def kind; ::Enumerable; end
  end

  def self.Enumerable?(*values)
    KIND.of?(::Enumerable, values)
  end
end
