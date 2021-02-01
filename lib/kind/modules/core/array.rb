# frozen_string_literal: true

module Kind
  module Array
    extend self, Core::Checker

    def kind; ::Array; end
  end

  def self.Array?(*values)
    Core::Utils.kind_of?(::Array, values)
  end
end
