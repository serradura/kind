# frozen_string_literal: true

module Kind
  module Struct
    extend self, Core::Checker

    def __kind__; ::Struct; end
  end

  def self.Struct?(*values)
    Core::Utils.kind_of?(::Struct, values)
  end
end
