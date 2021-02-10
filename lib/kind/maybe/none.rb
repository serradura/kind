# frozen_string_literal: true

module Kind
  module Maybe
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

      alias_method :map!, :map
      alias_method :then, :map
      alias_method :then!, :map

      def try!(method_name = Undefined, *args, &block)
        Kind::Symbol[method_name] if Undefined != method_name

        self
      end

      alias_method :try, :try!

      def dig(*keys)
        self
      end

      def presence
        self
      end

      private_constant :INVALID_DEFAULT_ARG
    end

    NONE_WITH_NIL_VALUE = None.new(nil)
    NONE_WITH_UNDEFINED_VALUE = None.new(Undefined)

    def none
      NONE_WITH_NIL_VALUE
    end

    def __none__(value) # :nodoc:
      None.new(value)
    end

    private_constant :NONE_WITH_NIL_VALUE, :NONE_WITH_UNDEFINED_VALUE
  end
end
