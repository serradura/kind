# frozen_string_literal: true

module Kind
  module Module
    extend self, Core::Checker

    def kind; ::Module; end

    def instance?(value)
      Kind.of_module?(value)
    end
  end

  def self.Module?(*values)
    Core::Utils.kind?(of: values, by: -> value {
      Kind.of_module?(value)
    })
  end
end
