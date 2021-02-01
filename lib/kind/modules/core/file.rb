# frozen_string_literal: true

module Kind
  module File
    extend self, Core::Checker

    def kind; ::File; end
  end

  def self.File?(*values)
    Core::Utils.kind_of?(::File, values)
  end
end
