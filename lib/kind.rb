# frozen_string_literal: true

require 'kind/version'
require 'kind/undefined'
require 'kind/maybe'
require 'kind/error'
require 'kind/is'
require 'kind/checker'
require 'kind/of'
require 'kind/types'

module Kind
  def self.is; Is; end
  def self.of; Of; end

  # -- Classes
  [
    String, Symbol, Numeric, Integer, Float, Regexp, Time,
    Array, Range, Hash, Struct, Enumerator,
    Method, Proc,
    IO, File
  ].each { |klass| Types.add(klass) }

  Types.add(Queue, name: 'Queue'.freeze)

  # -- Modules
  [
    Enumerable, Comparable
  ].each { |klass| Types.add(klass) }

  # --------------------- #
  # Special type checkers #
  # --------------------- #

  module Is
    def self.Boolean(value)
      klass = Kind.of.Class(value)
      klass <= TrueClass || klass <= FalseClass
    end

    def self.Callable(value)
      value.respond_to?(:call) || (value.is_a?(Module) && value.public_instance_methods.include?(:call))
    end
  end

  module Of
    # -- Boolean

    def self.Boolean(object = Undefined, options = {})
      default = options[:or]

      return Kind::Of::Boolean if object == Undefined && default.nil?

      bool = object.nil? ? default : object

      return bool if bool.is_a?(::TrueClass) || bool.is_a?(::FalseClass)

      raise Kind::Error.new('Boolean'.freeze, bool)
    end

    const_set(:Boolean, ::Module.new do
      extend Checker

      def self.__kind; [TrueClass, FalseClass].freeze; end

      def self.class?(value); Kind.is.Boolean(value); end

      def self.instance?(value);
        value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end
    end)

    # -- Lambda

    def self.Lambda(object = Undefined, options = {})
      default = options[:or]

      return Kind::Of::Lambda if object == Undefined && default.nil?

      func = object || default

      return func if func.is_a?(::Proc) && func.lambda?

      raise Kind::Error.new('Lambda'.freeze, func)
    end

    const_set(:Lambda, ::Module.new do
      extend Checker

      def self.__kind; ::Proc; end

      def self.instance?(value)
        value.is_a?(__kind) && value.lambda?
      end
    end)

    # -- Callable

    def self.Callable(object = Undefined, options = {})
      default = options[:or]

      return Kind::Of::Callable if object == Undefined && default.nil?

      callable = object || default

      return callable if callable.respond_to?(:call)

      raise Kind::Error.new('Callable'.freeze, callable)
    end

    const_set(:Callable, ::Module.new do
      extend Checker

      def self.__kind; Object; end

      def self.class?(value)
        Kind::Is::Callable(value)
      end

      def self.instance?(value);
        value.respond_to?(:call)
      end
    end)
  end
end
