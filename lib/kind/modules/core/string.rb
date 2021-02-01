# frozen_string_literal: true

module Kind
  module String
    extend self, Core::Checker

    def kind; ::String; end
  end

  def self.String?(*values)
    Core::Utils.kind_of?(::String, values)
  end
end
