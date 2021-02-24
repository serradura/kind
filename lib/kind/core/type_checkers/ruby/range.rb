# frozen_string_literal: true

module Kind
  module Range
    extend self, TypeChecker

    def kind; ::Range; end
  end

  def self.Range?(*values)
    KIND.of?(::Range, values)
  end
end
