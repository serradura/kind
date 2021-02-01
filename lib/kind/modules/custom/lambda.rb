# frozen_string_literal: true

module Kind
  module Lambda
    extend self, Core::Checker

    def kind; ::Proc; end

    def name; 'Lambda'; end

    def ===(value)
      value.kind_of?(::Proc) && value.lambda?
    end
  end

  def self.Lambda?(*values)
    Core::Utils.kind?(of: values, by: -> value {
      ::Kind::Lambda === value
    })
  end
end
