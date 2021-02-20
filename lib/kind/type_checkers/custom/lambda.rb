# frozen_string_literal: true

module Kind
  module Lambda
    extend self, TypeChecker

    def kind; ::Proc; end

    def name; 'Lambda'; end

    def ===(value)
      value.kind_of?(::Proc) && value.lambda?
    end
  end

  def self.Lambda?(*values)
    KIND.of?(Lambda, values)
  end
end
