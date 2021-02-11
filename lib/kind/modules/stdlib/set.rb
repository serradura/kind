# frozen_string_literal: true

module Kind
  module Set
    extend self, TypeChecker

    def kind; ::Set; end
  end

  def self.Set?(*values)
    KIND.of?(::Set, values)
  end
end
