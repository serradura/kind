# frozen_string_literal: true

module Kind
  module Enumerable
    extend self, Core::Checker

    def kind; ::Enumerable; end
  end

  def self.Enumerable?(*values)
    Core::Utils.kind_of?(::Enumerable, values)
  end
end
