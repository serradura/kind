# frozen_string_literal: true

module Kind
  module Set
    extend self, ::Kind::Object

    def kind; ::Set; end

    def value_or_empty(arg)
      KIND.value(self, arg, Empty::SET)
    end

    alias empty_or value_or_empty
  end

  def self.Set?(*values)
    KIND.of?(::Set, values)
  end
end
