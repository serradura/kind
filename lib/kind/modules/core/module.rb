# frozen_string_literal: true

module Kind
  module Module
    extend self, Core::Checker

    def kind; ::Module; end

    def ===(value)
      Kind.of_module?(value)
    end
  end

  def self.Module?(*values)
    Core::Utils.kind?(of: values, by: -> value {
      ::Kind::Module === value
    })
  end
end
