# frozen_string_literal: true

module Kind
  module Time
    extend self, CheckerMethods

    def __kind__; ::Time; end
  end

  def self.Time?(*values)
    CheckerUtils.kind_of?(::Time, values)
  end
end
