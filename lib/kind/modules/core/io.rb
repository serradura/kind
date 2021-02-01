# frozen_string_literal: true

module Kind
  module IO
    extend self, Core::Checker

    def kind; ::IO; end
  end

  def self.IO?(*values)
    Core::Utils.kind_of?(::IO, values)
  end
end
