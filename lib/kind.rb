# frozen_string_literal: true

require 'kind/version'

require 'ostruct'

require 'kind/empty'
require 'kind/undefined'
require 'kind/checker'
require 'kind/maybe'

require 'kind/error'
require 'kind/of'
require 'kind/is'
require 'kind/types'

module Kind
  WRONG_NUMBER_OF_ARGUMENTS = 'wrong number of arguments (given 1, expected 2)'.freeze

  private_constant :WRONG_NUMBER_OF_ARGUMENTS

  def self.is(expected = Undefined, object = Undefined)
    return Is if Undefined == expected && Undefined == object

    return Kind::Is.(expected, object) if Undefined != object

    raise ArgumentError, WRONG_NUMBER_OF_ARGUMENTS
  end

  def self.of(kind = Undefined, object = Undefined)
    return Of if Undefined == kind && Undefined == object

    return Kind::Of.(kind, object) if Undefined != object

    Kind::Checker::Factory.create(kind)
  end

  def self.of?(kind, *args)
    Kind.of(kind).instance?(*args)
  end

  # --------------------- #
  # Special type checkers #
  # --------------------- #

  module Is
    def self.Class(value)
      value.kind_of?(::Class)
    end

    def self.Module(value)
      ::Module == value || (value.is_a?(::Module) && !self.Class(value))
    end

    def self.Boolean(value)
      Kind.of.Class(value) <= TrueClass || value <= FalseClass
    end

    def self.Callable(value)
      value.respond_to?(:call)
    end
  end

  module Of
    # -- Class

    def self.Class(object = Undefined)
      return Class if Undefined == object

      self.call(::Class, object)
    end

    const_set(:Class, ::Module.new do
      extend Checker::Protocol

      def self.__kind; ::Class; end

      def self.class?(value); Kind::Is.Class(value); end

      def self.__is_instance__(value); class?(value); end
    end)

    def self.Class?(*args)
      Kind::Of::Class.instance?(*args)
    end

    # -- Module

    def self.Module(object = Undefined)
      return Module if Undefined == object

      self.call(::Module, object)
    end

    const_set(:Module, ::Module.new do
      extend Checker::Protocol

      def self.__kind_undefined(value)
        __kind_error(Kind::Undefined) if Kind::Undefined == value

        yield
      end

      def self.__kind_error(value)
        raise Kind::Error.new('Module'.freeze, value)
      end

      def self.__kind_of(value)
        return value if Kind::Is.Module(value)

        __kind_error(value)
      end

      def self.__kind; ::Module; end

      def self.class?(value); Kind::Is.Module(value); end

      def self.instance(value, options = Empty::HASH)
        default = options[:or]

        if ::Kind::Maybe::Value.none?(default)
          __kind_undefined(value) { __kind_of(value) }
        else
          return value if Kind::Undefined != value && instance?(value)

          __kind_undefined(default) { __kind_of(default) }
        end
      end

      def self.__is_instance__(value); class?(value); end
    end)

    def self.Module?(*args)
      Kind::Of::Module.instance?(*args)
    end

    # -- Boolean

    def self.Boolean(object = Undefined, options = Empty::HASH)
      default = options[:or]

      return Kind::Of::Boolean if Undefined == object && default.nil?

      bool = object.nil? ? default : object

      return bool if bool.is_a?(::TrueClass) || bool.is_a?(::FalseClass)

      raise Kind::Error.new('Boolean'.freeze, bool)
    end

    const_set(:Boolean, ::Module.new do
      extend Checker::Protocol

      def self.__kind; [TrueClass, FalseClass].freeze; end

      def self.class?(value); Kind.is.Boolean(value); end

      def self.instance(value, options= Empty::HASH)
        default = options[:or]

        if ::Kind::Maybe::Value.none?(default)
          __kind_undefined(value) { Kind::Of::Boolean(value) }
        else
          return value if Kind::Undefined != value && instance?(value)

          __kind_undefined(default) { Kind::Of::Boolean(default) }
        end
      end

      def self.__kind_undefined(value)
        if Kind::Undefined == value
          raise Kind::Error.new('Boolean'.freeze, Kind::Undefined)
        else
          yield
        end
      end

      def self.__is_instance__(value);
        value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end

      def self.or_undefined(value)
        result = or_nil(value)
        result.nil? ? Kind::Undefined : result
      end
    end)

    def self.Boolean?(*args)
      Kind::Of::Boolean.instance?(*args)
    end

    # -- Lambda

    def self.Lambda(object = Undefined, options = Empty::HASH)
      default = options[:or]

      return Kind::Of::Lambda if Undefined == object && default.nil?

      func = object || default

      return func if func.is_a?(::Proc) && func.lambda?

      raise Kind::Error.new('Lambda'.freeze, func)
    end

    const_set(:Lambda, ::Module.new do
      extend Checker::Protocol

      def self.__kind; ::Proc; end

      def self.instance(value, options = Empty::HASH)
        default = options[:or]

        if ::Kind::Maybe::Value.none?(default)
          __kind_undefined(value) { Kind::Of::Lambda(value) }
        else
          return value if Kind::Undefined != value && instance?(value)

          __kind_undefined(default) { Kind::Of::Lambda(default) }
        end
      end

      def self.__kind_undefined(value)
        if Kind::Undefined == value
          raise Kind::Error.new('Lambda'.freeze, Kind::Undefined)
        else
          yield
        end
      end

      def self.__is_instance__(value)
        value.is_a?(__kind) && value.lambda?
      end
    end)

    def self.Lambda?(*args)
      Kind::Of::Lambda.instance?(*args)
    end

    # -- Callable

    def self.Callable(object = Undefined, options = Empty::HASH)
      default = options[:or]

      return Kind::Of::Callable if Undefined == object && default.nil?

      callable = object || default

      return callable if callable.respond_to?(:call)

      raise Kind::Error.new('Callable'.freeze, callable)
    end

    const_set(:Callable, ::Module.new do
      extend Checker::Protocol

      def self.__kind; Object; end

      def self.class?(value)
        Kind::Is::Callable(value)
      end

      def self.instance(value, options = Empty::HASH)
        default = options[:or]

        if ::Kind::Maybe::Value.none?(default)
          __kind_undefined(value) { Kind::Of::Callable(value) }
        else
          return value if Kind::Undefined != value && instance?(value)

          __kind_undefined(default) { Kind::Of::Callable(default) }
        end
      end

      def self.__kind_undefined(value)
        if Kind::Undefined == value
          raise Kind::Error.new('Callable'.freeze, Kind::Undefined)
        else
          yield
        end
      end

      def self.__is_instance__(value);
        value.respond_to?(:call)
      end
    end)

    def self.Callable?(*args)
      Kind::Of::Callable.instance?(*args)
    end

    # ---------------------- #
    # Built-in type checkers #
    # ---------------------- #

    # -- Classes
    [
      String, Symbol, Numeric, Integer, Float, Regexp, Time,
      Array, Range, Hash, Struct, Enumerator, Set, OpenStruct,
      Method, Proc,
      IO, File
    ].each { |klass| Types.add(klass) }

    Types.add(Queue, name: 'Queue'.freeze)

    # -- Modules
    [
      Enumerable, Comparable
    ].each { |klass| Types.add(klass) }

    # -- Kind::Of::Maybe

    Types.add(Kind::Maybe::Result, name: 'Maybe'.freeze)
    Types.add(Kind::Maybe::Result, name: 'Optional'.freeze)
  end
end
