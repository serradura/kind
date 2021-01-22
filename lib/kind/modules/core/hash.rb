# frozen_string_literal: true

module Kind
  module Hash
    extend self, CheckerMethods

    def __kind__; ::Hash; end
  end

  def self.Hash?(*values)
    CheckerUtils.kind_of?(::Hash, values)
  end
end
