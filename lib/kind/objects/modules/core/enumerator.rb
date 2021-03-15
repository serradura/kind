# frozen_string_literal: true

module Kind
  module Enumerator
    extend self, ::Kind::Object

    def kind; ::Enumerator; end
  end

  def self.Enumerator?(*values)
    KIND.of?(::Enumerator, values)
  end
end
