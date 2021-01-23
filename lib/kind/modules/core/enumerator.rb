# frozen_string_literal: true

module Kind
  module Enumerator
    extend self, Core::Checker

    def __kind__; ::Enumerator; end
  end

  def self.Enumerator?(*values)
    Core::Utils.kind_of?(::Enumerator, values)
  end
end
