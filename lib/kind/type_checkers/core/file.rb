# frozen_string_literal: true

module Kind
  module File
    extend self, TypeChecker

    def kind; ::File; end
  end

  def self.File?(*values)
    KIND.of?(::File, values)
  end
end
