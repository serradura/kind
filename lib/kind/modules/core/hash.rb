# frozen_string_literal: true

module Kind
  module Hash
    extend self, Core::Checker

    def __kind__; ::Hash; end
  end

  def self.Hash?(*values)
    Core::Utils.kind_of?(::Hash, values)
  end
end
