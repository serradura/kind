# frozen_string_literal: true

require 'kind/version'

module Kind
  class Error < TypeError
    def initialize(klass, object)
      super("#{object.inspect} expected to be a kind of #{klass}")
    end
  end

  module Of
    def self.call(klass, object)
      return object if object.is_a?(klass)

      raise Kind::Error.new(klass, object)
    end

    def self.Class(object)
      self.call(::Class, object)
    end

    def self.Module(object)
      self.call(::Module, object)
    end

    def self.Boolean(object = nil)
      return Kind::Of::Boolean if object.nil?

      return object if object.is_a?(::TrueClass) || object.is_a?(::FalseClass)

      raise Kind::Error.new('Boolean'.freeze, object)
    end

    module Boolean
      def self.class?(value)
        Kind.is.Boolean(value)
      end

      def self.instance?(value)
        value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end

      def self.or_nil(value)
        return value if instance?(value)
      end
    end

    def self.Lambda(object = nil)
      return Kind::Of::Lambda if object.nil?

      return object if object.is_a?(::Proc) && object.lambda?

      raise Kind::Error.new('Lambda'.freeze, object)
    end

    module Lambda
      def self.class?(value)
        Kind.is.Proc(value)
      end

      def self.instance?(value)
        value.is_a?(::Proc) && value.lambda?
      end

      def self.or_nil(value)
        return value if instance?(value)
      end
    end
  end

  module Is
    def self.call(expected, value)
      expected_klass, klass = Kind.of.Module(expected), Kind.of.Module(value)

      klass <= expected_klass || false
    end

    def self.Class(value)
      value.is_a?(::Class)
    end

    def self.Module(value)
      value == Module || (value.is_a?(::Module) && !self.Class(value))
    end

    def self.Boolean(value)
      klass = Kind.of.Class(value)
      klass <= TrueClass || klass <= FalseClass
    end
  end

  def self.of; Of; end
  def self.is; Is; end

  module Types
    extend self

    KIND_OF = <<-RUBY
      def self.%{klass}(object = nil)
        return Kind::Of::%{klass} if object.nil?

        Kind::Of.call(::%{klass}, object)
      end
    RUBY

    KIND_IS = <<-RUBY
      def self.%{klass}(value)
        Kind::Is.call(::%{klass}, value)
      end
    RUBY

    KIND_OF_MODULE = <<-RUBY
      def self.class?(value)
        Kind::Is.call(::%{klass}, value)
      end

      def self.instance?(value)
        value.is_a?(::%{klass})
      end

      def self.or_nil(value)
        return value if instance?(value)
      end
    RUBY

    private_constant :KIND_OF, :KIND_IS, :KIND_OF_MODULE

    def add(klass)
      klass_name = Kind.of.Module(klass).name

      return if Of.respond_to?(klass_name)

      Of.instance_eval(KIND_OF % { klass: klass_name })

      type_module = Module.new
      type_module.instance_eval(KIND_OF_MODULE % { klass: klass_name })

      Of.const_set(klass_name, type_module)

      return if Is.respond_to?(klass_name)

      Is.instance_eval(KIND_IS % { klass: klass_name })
    end
  end

  # Classes
  [
    String, Symbol, Numeric, Integer, Float, Regexp, Time,
    Array, Range, Hash, Struct, Enumerator,
    Method, Proc,
    IO, File
  ].each { |klass| Types.add(klass) }

  # Modules
  [
    Enumerable, Comparable
  ].each { |klass| Types.add(klass) }
end
