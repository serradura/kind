# frozen_string_literal: true

module Kind
  module Set
    extend self, CheckerMethods

    def __kind__; ::Set; end
  end

  def self.Set?(*values)
    CheckerUtils.kind_of?(::Set, values)
  end
end
