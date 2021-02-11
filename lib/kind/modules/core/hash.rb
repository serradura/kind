# frozen_string_literal: true

module Kind
  module Hash
    extend self, TypeChecker

    def kind; ::Hash; end
  end

  def self.Hash?(*values)
    KIND.of?(::Hash, values)
  end
end
