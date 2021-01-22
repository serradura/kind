# frozen_string_literal: true

module Kind
  module IO
    extend self, CheckerMethods

    def __kind__; ::IO; end
  end

  def self.IO?(*values)
    CheckerUtils.kind_of?(::IO, values)
  end
end
