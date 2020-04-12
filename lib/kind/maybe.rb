# frozen_string_literal: true

module Kind
  module Maybe
    def self.none?(value)
      value == nil || value == Undefined
    end

    def self.some?(value)
      !none?(value)
    end

    def self.new(value)
      result_type = some?(value) ? Some : None
      result_type.new(value.is_a?(Result) ? value.value : value)
    end

    def self.[](value);
      new(value)
    end

    class Result
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
          Maybe.some?(default) ? default : block.call
        end
      end

      def none?; end

      def some?; !none?; end

      def map(&fn); end

      def try(method_name = Undefined, &block)
        fn = method_name == Undefined ? block : Kind.of.Symbol(method_name).to_proc

        if Maybe.some?(value)
          result = fn.call(value)

          return result if Maybe.some?(result)
        end
      end

      private_constant :INVALID_DEFAULT_ARG
    end

    class None < Result
      def none?; true; end

      def map(&fn)
        self
      end

      alias_method :then, :map
    end

    NONE_WITH_NIL = None.new(nil)
    NONE_WITH_UNDEFINED = None.new(Undefined)

    class Some < Result
      def none?; false; end

      def map(&fn)
        result = yield(@value)

        return NONE_WITH_NIL if result == nil
        return NONE_WITH_UNDEFINED if result == Undefined
        return Some.new(result)
      end

      alias_method :then, :map
    end

    private_constant :Result, :NONE_WITH_NIL, :NONE_WITH_UNDEFINED
  end

  Optional = Maybe
end
