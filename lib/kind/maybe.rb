# frozen_string_literal: true

require 'kind/dig'

module Kind
  module Maybe
    class Typed
      def initialize(kind)
        @kind_checker = Kind::Checker::Factory.create(kind)
      end

      def wrap(value)
        @kind_checker.as_maybe(value)
      end

      alias_method :new, :wrap
      alias_method :[], :wrap
    end

    module Value
      def self.none?(value)
        value.nil? || Undefined == value
      end

      def self.some?(value)
        !none?(value)
      end
    end

    class Result
      attr_reader :value

      def initialize(value)
        @value = value.kind_of?(Result) ? value.value : value
      end

      def value_or(method_name = Undefined, &block)
        raise NotImplementedError
      end

      def none?
        raise NotImplementedError
      end

      def some?; !none?; end

      def map(&fn)
        raise NotImplementedError
      end

      def try(method_name = Undefined, &block)
        raise NotImplementedError
      end
    end

    class None < Result
      INVALID_DEFAULT_ARG = 'the default value must be defined as an argument or block'.freeze

      def value_or(default = Undefined, &block)
        raise ArgumentError, INVALID_DEFAULT_ARG if Undefined == default && !block

        Undefined != default ? default : block.call
      end

      def none?; true; end

      def map(&fn)
        self
      end

      alias_method :then, :map

      def try!(method_name = Undefined, *args, &block)
        Kind::Symbol[method_name] if Undefined != method_name

        NONE_WITH_NIL_VALUE
      end

      alias_method :try, :try!

      def dig(*keys)
        NONE_WITH_NIL_VALUE
      end

      private_constant :INVALID_DEFAULT_ARG
    end

    NONE_WITH_NIL_VALUE = None.new(nil)
    NONE_WITH_UNDEFINED_VALUE = None.new(Undefined)

    private_constant :NONE_WITH_NIL_VALUE, :NONE_WITH_UNDEFINED_VALUE

    class Some < Result
      def value_or(default = Undefined, &block)
        @value
      end

      def none?; false; end

      def map(&fn)
        result = fn.call(@value)

        resolve(result)
      end

      alias_method :then, :map

      def try!(method_name = Undefined, *args, &block)
        return __try_block__(block, args) if block

        return __try_method__(method_name, args) if Undefined != method_name

        raise ArgumentError, 'method name or a block must be present'
      end

      def try(method_name = Undefined, *args, &block)
        return __try_block__(block, args) if block

        return __try_method__(method_name, args) if value.respond_to?(method_name)

        NONE_WITH_NIL_VALUE
      end

      def dig(*keys)
        resolve(Kind::Dig.call(value, keys))
      end

      private

        def __try_method__(method_name, args)
          __try_block__(Kind::Symbol[method_name].to_proc, args)
        end

        def __try_block__(block, args)
          result = args.empty? ? block.call(value) : block.call(*args.unshift(value))

          resolve(result)
        end

        def resolve(result)
          return result if Maybe::None === result
          return NONE_WITH_NIL_VALUE if result.nil?
          return NONE_WITH_UNDEFINED_VALUE if Undefined == result

          Some.new(result)
        end
    end

    def self.new(value)
      result_type = Maybe::Value.none?(value) ? None : Some
      result_type.new(value)
    end

    def self.[](value)
      new(value)
    end

    def self.wrap(value)
      new(value)
    end

    def self.none
      NONE_WITH_NIL_VALUE
    end

    VALUE_CANT_BE_NONE = "value can't be nil or Kind::Undefined".freeze

    private_constant :VALUE_CANT_BE_NONE

    def self.some(value)
      return Maybe::Some.new(value) if Value.some?(value)

      raise ArgumentError, VALUE_CANT_BE_NONE
    end
  end

  Optional = Maybe

  None = Maybe.none

  def self.None
    Kind::None
  end

  def self.Some(value)
    Maybe.some(value)
  end

  def self.Maybe(kind)
    Maybe::Typed.new(kind)
  end

  def self.Optional(kind)
    Maybe::Typed.new(kind)
  end
end
