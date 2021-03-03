# frozen_string_literal: true

require 'kind'

module Kind
  module Functional
    def self.extended(_)
      raise RuntimeError, "The Kind::Functional can't be extended, it can be only included."
    end

    def self.included(base)
      Kind::Class[base].send(:extend, ClassMethods)
    end

    module Behavior
      def self.included(base)
        base.send(:alias_method, :[], :call)
        base.send(:alias_method, :===, :call)
        base.send(:alias_method, :yield, :call)
      end

      def initialize(arg = Empty::HASH)
        hash = Kind::Hash[arg]

        self.class.__dependencies__.each do |name, (kind, default)|
          value = hash[name]

          if kind == ::Proc || kind == Kind::Proc || kind == Kind::Lambda
            value_to_assign =
              UNDEFINED == default ? value : KIND.value(kind, value, default)

            instance_variable_set("@#{name}", Kind::Proc[value_to_assign, label: name])
          else
            default_value =
              if default.respond_to?(:call)
                default_fn = Proc === default ? default : default.method(:call)

                default_fn.arity > 0 ? default_fn.call(value) : default_fn.call
              else
                default
              end

            value_to_assign =
              UNDEFINED == default_value ? value : KIND.value(kind, value, default_value)

            instance_variable_set("@#{name}", Kind.of(kind, value_to_assign, label: name))
          end
        end
      end
    end

    module DependencyInjection
      def __dependencies__ # :nodoc:
        @__dependencies__ ||= {}
      end

      def dependency(name, kind, default: UNDEFINED)
        __dependencies__[Kind::Symbol[name]] = [Kind::NotNil[kind], default]

        attr_reader(name)

        private name

        name
      end
    end

    module ClassMethods
      include DependencyInjection

      def require_functional_contract!
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
