# frozen_string_literal: true

require 'kind/basic'

module Kind
  module Function
    module Behavior
      def self.extended(base)
        base.send(:alias_method, :[], :call)
        base.send(:alias_method, :===, :call)
        base.send(:alias_method, :yield, :call)
      end
    end

    def self.included(_)
      raise RuntimeError, "The Kind::Function can't be included, it can be only extended."
    end

    def self.extended(base)
      KIND.error!('Module', base) unless Kind.of_module?(base)

      base.extend(base)
    end

    def require_function_contract!
      return self if Kind.is(Behavior, self)

      KIND.respond_to!(:call, self).extend(Behavior)

      if method(:call).parameters.empty?
        raise ArgumentError, "#{self.name}.call must receive at least one argument"
      end

      self.instance_eval(
        'def to_proc; @to_proc ||= method(:call).to_proc; end' \
        "\n" \
        'def curry; @curry ||= to_proc.curry; end'
      )

      self.to_proc
      self.curry
      self
    end

    private_constant :Behavior
  end
end
