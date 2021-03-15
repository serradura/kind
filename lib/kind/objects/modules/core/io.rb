# frozen_string_literal: true

module Kind
  module IO
    extend self, ::Kind::Object

    def kind; ::IO; end
  end

  def self.IO?(*values)
    KIND.of?(::IO, values)
  end
end
