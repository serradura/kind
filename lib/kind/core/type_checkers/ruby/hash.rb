# frozen_string_literal: true

module Kind
  module Hash
    extend self, TypeChecker

    def kind; ::Hash; end

    def value_or_empty(arg)
      KIND.value(self, arg, Empty::HASH)
    end
  end

  def self.Hash?(*values)
    KIND.of?(::Hash, values)
  end
end
