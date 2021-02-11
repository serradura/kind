# frozen_string_literal: true

module Kind
  module Module
    extend self, TypeChecker

    def kind; ::Module; end

    def ===(value)
      Kind.of_module?(value)
    end
  end

  def self.Module?(*values)
    KIND.check(values, by: -> value {
      ::Kind::Module === value
    })
  end
end
