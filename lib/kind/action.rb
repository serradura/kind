# frozen_string_literal: true

require 'kind/basic'
require 'kind/result'
require 'kind/immutable_attributes'

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

    def self.included(base)
      KIND.of!(::Class, base).extend(ClassMethods)

      base.send(:include, ImmutableAttributes::Reader)
    end

    include ImmutableAttributes::Initializer

    private

      def Failure(arg1 = UNDEFINED, arg2 = UNDEFINED)
        Result::Failure[arg1, arg2, value_must_be_a: ::Hash]
      end

      def Success(arg1 = UNDEFINED, arg2 = UNDEFINED)
        Result::Success[arg1, arg2, value_must_be_a: ::Hash]
      end
  end
end
