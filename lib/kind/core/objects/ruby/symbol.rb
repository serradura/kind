# frozen_string_literal: true

module Kind
  module Symbol
    extend self, ::Kind::Object

    def kind; ::Symbol; end
  end

  def self.Symbol?(*values)
    KIND.of?(::Symbol, values)
  end
end
