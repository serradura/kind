# frozen_string_literal: true

module Kind
  module Boolean
    extend self, TypeChecker

    def kind; [TrueClass, FalseClass].freeze; end

    def name; 'Boolean'; end

    def ===(value)
      ::TrueClass === value || ::FalseClass === value
    end
  end

  def self.Boolean?(*values)
    KIND.of?(Boolean, values)
  end
end