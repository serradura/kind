# frozen_string_literal: true

module Kind
  module Module
    extend self, CheckerMethods

    def __kind__; ::Module; end

    def instance?(value)
      Kind.of_module?(kind)
    end
  end

  def self.Module?(*values)
    kind_of_by(
      fn: -> value { Kind.of_module?(kind) },
      values: values
    )
  end
end