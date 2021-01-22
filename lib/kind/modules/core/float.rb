# frozen_string_literal: true

module Kind
  module Float
    extend self, CheckerMethods

    def __kind__; ::Float; end
  end

  def self.Float?(*values)
    CheckerUtils.kind_of?(::Float, values)
  end
end
