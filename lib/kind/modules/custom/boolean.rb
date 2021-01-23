# frozen_string_literal: true

module Kind
  module Boolean
    extend self, Core::Checker

    def __kind__; [TrueClass, FalseClass].freeze; end

    def __kind_name__; 'Boolean'; end

    def instance?(value)
      ::TrueClass === value || ::FalseClass === value
    end
  end

  def self.Boolean?(*values)
    Core::Utils.kind?(of: values, by: -> value {
      Boolean.instance?(value)
    })
  end
end
