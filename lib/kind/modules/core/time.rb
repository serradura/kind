# frozen_string_literal: true

module Kind
  module Time
    extend self, TypeChecker

    def kind; ::Time; end
  end

  def self.Time?(*values)
    KIND.of?(::Time, values)
  end
end
