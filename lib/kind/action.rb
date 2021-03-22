# frozen_string_literal: true

require 'kind/basic'
require 'kind/empty'
require 'kind/result'
require 'kind/immutable_attributes'
require 'kind/__lib__/action_steps'

module Kind
  module Action
    CALL_TMPL = [
      'def self.call(arg)',
      '  new(Kind.of!(::Hash, arg)).call',
      'end',
      '',
      'def call',
      '  result = call!',
      '',
      '  return result if Kind::Result::Monad === result',
      '',
      '  raise Kind::Error, "#{self.class.name}#call! must return a Success() or Failure()"',
      'end'
    ].join("\n").freeze

    private_constant :CALL_TMPL

    module ClassMethods
      include ImmutableAttributes::ClassMethods

      def to_proc
        @to_proc ||= ->(arg) { call(arg) }
      end

      ATTRIBUTE_METHODS = [
        :attributes, :attribute,
        :attribute?, :attribute!,
        :with_attribute, :with_attributes,
        :nil_attributes, :nil_attributes?
      ]

      private_constant :ATTRIBUTE_METHODS

      def kind_action!
        return self if respond_to?(:call)

        public_methods = self.public_instance_methods - ::Object.new.methods

        remaining_methods = public_methods - (__attributes__.keys + ATTRIBUTE_METHODS)

        unless remaining_methods.include?(:call!)
          raise Kind::Error.new("expected #{self} to implement `#call!`")
        end

        if remaining_methods.size > 1
          raise Kind::Error.new("#{self} can only have `#call!` as its public method")
        end

        call_parameters = public_instance_method(:call!).parameters

        unless call_parameters.empty?
          raise ArgumentError, "#{self.name}#call! must receive no arguments"
        end

        def self.inherited(_)
          raise RuntimeError, "#{self.name} is a Kind::Action and it can't be inherited"
        end

        self.send(:private_class_method, :new)

        self.class_eval(CALL_TMPL)

        self.send(:alias_method, :[], :call)
        self.send(:alias_method, :===, :call)
        self.send(:alias_method, :yield, :call)
      end
    end

    module StepAdapters
      private

        def Check!(mthod); __Check(mthod, Empty::HASH); end
        def Step!(mthod); __Step(mthod, Empty::HASH); end
        def Map!(mthod); __Map(mthod, Empty::HASH); end
        def Tee!(_mthod); raise NotImplementedError; end
        def Try!(mthod, opt = Empty::HASH); __Try(mthod, Empty::HASH, opt); end

        def __resolve_step(method_name, value)
          m = method(method_name)
          m.arity > 0 ? m.call(value) : m.call
        end

        def __map_step_exception(value)
          { exception: value }
        end
    end

    private_constant :StepAdapters

    def self.included(base)
      Kind.of_class(base).extend(ClassMethods)

      base.send(:include, ACTION_STEPS)
      base.send(:include, StepAdapters)
      base.send(:include, ImmutableAttributes::Reader)
    end

    include ImmutableAttributes::Initializer

    def inspect
      '#<%s attributes=%p nil_attributes=%p>' % [self.class.name, attributes, nil_attributes]
    end

    private

      def Failure(arg1 = UNDEFINED, arg2 = UNDEFINED)
        arg1 = Empty::HASH if UNDEFINED == arg1 && UNDEFINED == arg2

        Result::Failure[arg1, arg2, value_must_be_a: ::Hash]
      end

      def Success(arg1 = UNDEFINED, arg2 = UNDEFINED)
        arg1 = Empty::HASH if UNDEFINED == arg1 && UNDEFINED == arg2

        Result::Success[arg1, arg2, value_must_be_a: ::Hash]
      end
  end
end
