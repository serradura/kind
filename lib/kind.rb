# frozen_string_literal: true

require 'kind/version'

module Kind
  Undefined = Object.new.tap do |undefined|
    def undefined.inspect
      @inspect ||= 'Undefined'.freeze
    end

    def undefined.to_s
      inspect
    end

    def undefined.clone
      self
    end

    def undefined.dup
      clone
    end

    def undefined.default(value, default)
      return self if value != self

      default.respond_to?(:call) ? default.call : default
    end
  end

  class Optional
    self.singleton_class.send(:alias_method, :[], :new)

    IsNone = -> value { value == nil || value == Undefined }

    attr_reader :value

    def initialize(value)
      @value = value
    end

    INVALID_DEFAULT_ARG = 'the default value must be defined as an argument or block'.freeze

    def value_or(default = Undefined, &block)
      return @value if some?

      if default == Undefined && !block
        raise ArgumentError, INVALID_DEFAULT_ARG
      else
        IsNone.(default) ? block.call : default
      end
    end

    def none?
      @none ||= IsNone.(@value)
    end

    def some?
      !none?
    end

    def map(&fn)
      return self if none?

      self.class.new(fn.call(@value))
    end

    alias_method :then, :map

    def try(method_name = Undefined, &block)
      fn = method_name == Undefined ? block : Kind.of.Symbol(method_name).to_proc

      unless IsNone.(value)
        result = fn.call(value)

        return result unless IsNone.(result)
      end
    end
  end

  class Error < TypeError
    def initialize(klass, object)
      super("#{object.inspect} expected to be a kind of #{klass}")
    end
  end

  module Is
    def self.call(expected, value)
      expected_mod = Kind::Of.Module(expected)
      mod = Kind::Of.Module(value)

      mod <= expected_mod || false
    end

    def self.Class(value)
      value.is_a?(::Class)
    end

    def self.Module(value)
      value == ::Module || (value.is_a?(::Module) && !self.Class(value))
    end
  end

  module Checker
    def class?(value)
      Kind::Is.(__kind, value)
    end

    def instance?(value)
      value.is_a?(__kind)
    end

    def or_nil(value)
      return value if instance?(value)
    end
  end

  module Of
    def self.call(klass, object, name: nil)
      return object if object.is_a?(klass)

      raise Kind::Error.new((name || klass.name), object)
    end

    def self.Class(object = Undefined)
      return Class if object == Undefined

      self.call(::Class, object)
    end

    const_set(:Class, ::Module.new do
      extend Checker

      def self.__kind; ::Class; end

      def self.class?(value); Kind::Is.Class(value); end

      def self.instance?(value); class?(value); end
    end)

    def self.Module(object = Undefined)
      return Module if object == Undefined

      self.call(::Module, object)
    end

    const_set(:Module, ::Module.new do
      extend Checker

      def self.__kind; ::Module; end

      def self.class?(value); Kind::Is.Module(value); end

      def self.instance?(value); class?(value); end
    end)
  end

  module Types
    extend self

    COLONS = '::'.freeze

    KIND_OF = <<-RUBY
      def self.%{method_name}(object = Undefined, options = {})
        default = options[:or]

        return Kind::Of::%{kind_name} if object == Undefined && default.nil?

        Kind::Of.(::%{kind_name}, (object || default), name: "%{kind_name}".freeze)
      end
    RUBY

    KIND_IS = <<-RUBY
      def self.%{method_name}(value = Undefined)
        return Kind::Is::%{kind_name} if value == Undefined

        Kind::Is.(::%{kind_name}, value)
      end
    RUBY

    private_constant :KIND_OF, :KIND_IS, :COLONS

    def add(kind, name: nil)
      kind_name = Kind.of.Module(kind).name
      checker = name ? Kind::Of.(String, name) : kind_name

      case
      when checker.include?(COLONS)
        add_kind_with_namespace(checker, method_name: name)
      else
        add_root(checker, kind_name, method_name: name, create_kind_is_mod: false)
      end
    end

    private

      def add_root(checker, kind_name, method_name:, create_kind_is_mod:)
        root_checker = method_name ? method_name : checker
        root_kind_name = method_name ? method_name : kind_name

        add_kind(root_checker, root_kind_name, Kind::Of, Kind::Is, create_kind_is_mod)
      end

      def add_kind_with_namespace(checker, method_name:)
        raise NotImplementedError if method_name

        const_names = checker.split(COLONS)
        const_names.each_with_index do |const_name, index|
          if index == 0
            add_root(const_name, const_name, method_name: nil, create_kind_is_mod: true)
          else
            add_node(const_names, index)
          end
        end
      end

      def add_node(const_names, index)
        namespace = const_names[0..(index-1)]
        namespace_name = namespace.join(COLONS)

        kind_of_mod = Kind::Of.const_get(namespace_name)
        kind_is_mod = Kind::Is.const_get(namespace_name)

        checker = const_names[index]
        kind_name = const_names[0..index].join(COLONS)

        add_kind(checker, kind_name, kind_of_mod, kind_is_mod, true)
      end

      def add_kind(checker, kind_name, kind_of_mod, kind_is_mod, create_kind_is_mod)
        params = { method_name: checker, kind_name: kind_name }

        unless kind_of_mod.respond_to?(checker)
          kind_checker = ::Module.new { extend Checker }
          kind_checker.module_eval("def self.__kind; #{kind_name}; end")

          kind_of_mod.instance_eval(KIND_OF % params)
          kind_of_mod.const_set(checker, kind_checker)
        end

        unless kind_is_mod.respond_to?(checker)
          kind_is_mod.instance_eval(KIND_IS % params)
          kind_is_mod.const_set(checker, Module.new) if create_kind_is_mod
        end
      end
  end

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
  end

  private_constant :Checker
end
