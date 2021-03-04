# frozen_string_literal: true

module Kind
  module Hash
    extend self, ::Kind::Object

    def kind; ::Hash; end

    def value_or_empty(arg)
      KIND.value(self, arg, Empty::HASH)
    end

    alias empty_or value_or_empty
  end

  def self.Hash?(*values)
    KIND.of?(::Hash, values)
  end
end
