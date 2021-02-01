# frozen_string_literal: true

module Kind
  module Lambda
    extend self, Core::Checker

    def kind; ::Proc; end

    def name; 'Lambda'; end

    def instance?(value)
      value.kind_of?(::Proc) && value.lambda?
    end
  end

  def self.Lambda?(*values)
    Core::Utils.kind?(of: values, by: -> value {
      Lambda.instance?(value)
    })
  end
end
