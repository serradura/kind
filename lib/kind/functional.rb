# frozen_string_literal: true

require 'kind/basic'
require 'kind/empty'
require 'kind/__lib__/attributes'

module Kind
  module Functional
    def self.extended(_)
      raise RuntimeError, "The Kind::Functional can't be extended, it can be only included."
    end

    def self.included(base)
      Kind.of_class(base).send(:extend, ClassMethods)
    end

    module Behavior
      def self.included(base)
        base.send(:alias_method, :[], :call)
        base.send(:alias_method, :===, :call)
        base.send(:alias_method, :yield, :call)
      end

      def initialize(arg = Empty::HASH)
        hash = STRICT.kind_of(::Hash, arg)

        self.class.__dependencies__.each do |name, (kind, default, _visibility)|
          value_to_assign = ATTRIBUTES.value_to_assign!(kind, default, hash, name)

          instance_variable_set("@#{name}", value_to_assign)
        end
      end
    end

    module DependencyInjection
      def __dependencies__ # :nodoc:
        @__dependencies__ ||= {}
      end

      def dependency(name, kind, default: UNDEFINED)
        __dependencies__[ATTRIBUTES.name!(name)] = ATTRIBUTES.value!(kind, default)

        attr_reader(name)

        private(name)

        name
      end
    end

    module ClassMethods
      include DependencyInjection

      def kind_functional!
        return self if Kind.is?(Behavior, self)

        public_methods = self.public_instance_methods - ::Object.new.methods

        unless public_methods.include?(:call)
          raise Kind::Error.new("expected #{self} to implement `#call`")
        end

        if public_methods.size > 1
          raise Kind::Error.new("#{self} can only have `#call` as its public method")
        end

        if public_instance_method(:call).parameters.empty?
          raise ArgumentError, "#{self.name}#call must receive at least one argument"
        end

        self.send(:include, Behavior)

        def self.inherited(_)
          raise RuntimeError, "#{self.name} is a Kind::Functional and it can't be inherited by anyone"
        end

        self.class_eval(
          'def to_proc; @to_proc ||= method(:call).to_proc; end' \
          "\n" \
          'def curry; @curry ||= to_proc.curry; end'
        )

        __dependencies__.freeze

        self
      end
    end
  end
end
