# frozen_string_literal: true

module Kind
  module Symbol
    def self.call(value); Of.(::Symbol, value) ;end
  end
end
