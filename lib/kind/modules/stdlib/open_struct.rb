# frozen_string_literal: true

module Kind
  module OpenStruct
    extend self, Core::Checker

    def __kind__; ::OpenStruct; end
  end

  def self.OpenStruct?(*values)
    Core::Utils.kind_of?(::OpenStruct, values)
  end
end
