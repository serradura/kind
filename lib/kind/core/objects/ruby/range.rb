# frozen_string_literal: true

module Kind
  module Range
    extend self, ::Kind::Object

    def kind; ::Range; end
  end

  def self.Range?(*values)
    KIND.of?(::Range, values)
  end
end
