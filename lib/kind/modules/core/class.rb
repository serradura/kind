# frozen_string_literal: true

module Kind
  module Class
    extend self, CheckerMethods

    def __kind__; ::Class; end
  end

  def self.Class?(*values)
    CheckerUtils.kind_of?(::Class, values)
  end
end
