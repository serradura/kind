# frozen_string_literal: true

module Kind
  module Lambda
    extend self, Core::Checker

    def __kind__; ::Proc; end

    def __kind_name__; 'Lambda'; end

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
