# frozen_string_literal: true

module Kind
  module Symbol
    extend self, Core::Checker

    def kind; ::Symbol; end
  end

  def self.Symbol?(*values)
    Core::Utils.kind_of?(::Symbol, values)
  end
end
