# frozen_string_literal: true

module Kind
  module Integer
    extend self, TypeChecker

    def kind; ::Integer; end
  end

  def self.Integer?(*values)
    KIND.of?(::Integer, values)
  end
end
