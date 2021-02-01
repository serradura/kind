# frozen_string_literal: true

module Kind
  module Integer
    extend self, Core::Checker

    def kind; ::Integer; end
  end

  def self.Integer?(*values)
    Core::Utils.kind_of?(::Integer, values)
  end
end
