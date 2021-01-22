# frozen_string_literal: true

module Kind
  module File
    extend self, CheckerMethods

    def __kind__; ::File; end
  end

  def self.File?(*values)
    CheckerUtils.kind_of?(::File, values)
  end
end
