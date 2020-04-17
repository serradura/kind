# frozen_string_literal: true

module Kind
  module Maybe
    module Value
      def self.none?(value)
        value == nil || value == Undefined
      end

      def self.some?(value)
        !none?(value)
      end
    end

    class Result
      attr_reader :value

      def initialize(value)
        @value = value
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
        raise ArgumentError, INVALID_DEFAULT_ARG if default == Undefined && !block

        Maybe::Value.some?(default) ? default : block.call
      end

      def none?; true; end

      def map(&fn)
        self
      end

      alias_method :then, :map

      def try(method_name = Undefined, &block)
        Kind.of.Symbol(method_name) if method_name != Undefined

        nil
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

        return NONE_WITH_NIL_VALUE if result == nil
        return NONE_WITH_UNDEFINED_VALUE if result == Undefined

        Some.new(result)
      end

      alias_method :then, :map

      def try(method_name = Undefined, &block)
        fn = method_name == Undefined ? block : Kind.of.Symbol(method_name).to_proc

        result = fn.call(value)

        return result if Maybe::Value.some?(result)
      end
    end

    def self.new(value)
      result_type = Maybe::Value.none?(value) ? None : Some
      result_type.new(value.is_a?(Result) ? value.value : value)
    end

    def self.[](value);
      new(value)
    end
  end

  Optional = Maybe
end
