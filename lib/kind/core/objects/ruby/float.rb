# frozen_string_literal: true

module Kind
  module Float
    extend self, ::Kind::Object

    def kind; ::Float; end
  end

  def self.Float?(*values)
    KIND.of?(::Float, values)
  end
end
