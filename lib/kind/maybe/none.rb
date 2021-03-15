# frozen_string_literal: true

module Kind
  module Maybe
    class None < Monad
      def value_or(default = UNDEFINED, &block)
        Error.invalid_default_arg! if UNDEFINED == default && !block

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
      alias_method :and_then, :map
      alias_method :and_then!, :map!

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

    NONE_INSTANCE = None.new(nil)
  end
end
