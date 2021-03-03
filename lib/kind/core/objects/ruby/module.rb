# frozen_string_literal: true

module Kind
  module Module
    extend self, ::Kind::Object

    def kind; ::Module; end

    def ===(value)
      Kind.of_module?(value)
    end
  end

  def self.Module?(*values)
    KIND.of?(::Kind::Module, values)
  end
end
