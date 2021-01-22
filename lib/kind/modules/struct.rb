# frozen_string_literal: true

module Kind
  module Struct
    extend self, CheckerMethods

    def __kind__; ::Struct; end
  end

  def self.Struct?(*values)
    CheckerUtils.kind_of?(::Struct, values)
  end
end
