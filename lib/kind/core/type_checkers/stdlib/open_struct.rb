# frozen_string_literal: true

module Kind
  module OpenStruct
    extend self, TypeChecker

    def kind; ::OpenStruct; end
  end

  def self.OpenStruct?(*values)
    KIND.of?(::OpenStruct, values)
  end
end
