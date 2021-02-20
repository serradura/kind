# frozen_string_literal: true

module Kind
  module String
    extend self, TypeChecker

    def kind; ::String; end
  end

  def self.String?(*values)
    KIND.of?(::String, values)
  end
end
