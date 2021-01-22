# frozen_string_literal: true

module Kind
  module OpenStruct
    extend self, CheckerMethods

    def __kind__; ::OpenStruct; end
  end

  def self.OpenStruct?(*values)
    CheckerUtils.kind_of?(::OpenStruct, values)
  end
end
