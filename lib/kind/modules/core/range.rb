# frozen_string_literal: true

module Kind
  module Range
    extend self, Core::Checker

    def kind; ::Range; end
  end

  def self.Range?(*values)
    Core::Utils.kind_of?(::Range, values)
  end
end
