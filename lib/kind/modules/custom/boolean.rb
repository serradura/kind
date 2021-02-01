# frozen_string_literal: true

module Kind
  module Boolean
    extend self, Core::Checker

    def kind; [TrueClass, FalseClass].freeze; end

    def name; 'Boolean'; end

    def ===(value)
      ::TrueClass === value || ::FalseClass === value
    end
  end

  def self.Boolean?(*values)
    Core::Utils.kind?(of: values, by: -> value {
      ::Kind::Boolean === value
    })
  end
end
