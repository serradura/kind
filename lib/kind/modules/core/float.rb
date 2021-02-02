# frozen_string_literal: true

module Kind
  module Float
    extend self, Core::Checker

    def kind; ::Float; end
  end

  def self.Float?(*values)
    Core::Utils.kind_of?(::Float, values)
  end
end
