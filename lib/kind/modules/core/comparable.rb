# frozen_string_literal: true

module Kind
  module Comparable
    extend self, Core::Checker

    def __kind__; ::Comparable; end
  end

  def self.Comparable?(*values)
    Core::Utils.kind_of?(::Comparable, values)
  end
end
