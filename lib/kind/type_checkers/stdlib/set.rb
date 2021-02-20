# frozen_string_literal: true

module Kind
  module Set
    extend self, TypeChecker

    def kind; ::Set; end

    def value_or_empty(arg)
      __value(arg, Empty::SET)
    end
  end

  def self.Set?(*values)
    KIND.of?(::Set, values)
  end
end
