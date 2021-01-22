# frozen_string_literal: true

module Kind
  module String
    extend self, CheckerMethods

    def __kind__; ::String; end
  end

  def self.String?(*values)
    CheckerUtils.kind_of?(::String, values)
  end
end
