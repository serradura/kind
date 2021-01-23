# frozen_string_literal: true

module Kind
  module Time
    extend self, Core::Checker

    def __kind__; ::Time; end
  end

  def self.Time?(*values)
    Core::Utils.kind_of?(::Time, values)
  end
end
