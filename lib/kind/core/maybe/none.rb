# frozen_string_literal: true

module Kind
  module Maybe
    class None < Result
      def value_or(default = UNDEFINED, &block)
        ARGS_ERROR.invalid_default! if UNDEFINED == default && !block

        UNDEFINED != default ? default : block.call
      end

      def none?; true; end

      def map(_method_name = UNDEFINED, &fn)
        self
      end

      alias_method :map!, :map
      alias_method :then, :map
      alias_method :then!, :map
      alias_method :check, :map
      alias_method :accept, :map
      alias_method :reject, :map

      def try!(method_name = UNDEFINED, *args, &block)
        KIND.of!(::Symbol, method_name)if UNDEFINED != method_name

        self
      end

      alias_method :try, :try!

      def dig(*keys)
        self
      end

      def presence
        self
      end

      def inspect
        '#<%s value=%s>' % ['Kind::None', value.inspect]
      end
    end

    NONE_WITH_NIL_VALUE = None.new(nil)
    NONE_WITH_UNDEFINED_VALUE = None.new(Undefined)

    def self.none
      NONE_WITH_NIL_VALUE
    end

    def self.__none__(value) # :nodoc:
      None.new(value)
    end

    private_constant :NONE_WITH_NIL_VALUE, :NONE_WITH_UNDEFINED_VALUE
  end
end
