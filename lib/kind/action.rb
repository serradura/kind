# frozen_string_literal: true

require 'kind'
require 'kind/result'
require 'kind/functional'

module Kind
  module Action
    module Behavior
      private

        def Success(type = UNDEFINED, value = UNDEFINED)
          Kind::Success(type, value)
        end

        def Failure(type = UNDEFINED, value = UNDEFINED)
          Kind::Failure(type, value)
        end
    end

    CALL_TMPL = [
      'def call(%s)',
      '  result = call!(%s)',
      '',
      '  return result if Kind::Result::Object === result',
      '',
      '  raise Kind::Error, "#{self.class.name}#call! must return a Kind::Success or Kind::Failure"',
      'end'
    ].join("\n").freeze

    module Macros
      def require_action_contract!
        return self if Kind.is(Behavior, self)

        public_methods = self.public_instance_methods - Object.new.methods

        unless public_methods.include?(:call!)
          raise Kind::Error.new("expected #{self} to implement `#call!`")
        end

        if public_methods.size > 1
          raise Kind::Error.new("#{self} can only have `#call!` as its public method")
        end

        call_parameters = public_instance_method(:call!).parameters

        if call_parameters.empty?
          raise ArgumentError, "#{self.name}#call! must receive at least one argument"
        end

        def self.inherited(_)
          raise RuntimeError, "#{self.name} is a Kind::Action and it can't be inherited by anyone"
        end

        call_parameters.flatten!

        call_with_args = call_parameters.include?(:req) || call_parameters.include?(:rest)
        call_with_kargs = call_parameters.include?(:keyreq) || call_parameters.include?(:keyrest)

        call_tmpl_args = '*args, **kargs' if call_with_args && call_with_kargs
        call_tmpl_args = '*args'          if call_with_args && !call_with_kargs
        call_tmpl_args = '**kargs'        if !call_with_args && call_with_kargs

        self.class_eval(
          "def to_proc; @to_proc ||= method(:call!).to_proc; end" \
          "\n" \
          "def curry; @curry ||= to_proc.curry; end" \
          "\n" \
          "#{CALL_TMPL % [call_tmpl_args, call_tmpl_args]}"
        )

        if KIND.of_module?(self)
          self.send(:extend, Behavior)
        else
          self.send(:include, Functional::Behavior)
          self.send(:include, Behavior)

          __dependencies__.freeze
        end

        self.send(:protected, :call!)

        self
      end
    end

    def self.included(base)
      Kind::Class[base].send(:extend, Functional::DependencyInjection)

      base.send(:extend, Macros)
    end

    def self.extended(base)
      Kind::Module[base].send(:extend, base)

      base.send(:extend, Macros)
    end

    private_constant :Behavior, :Macros, :CALL_TMPL
  end
end
