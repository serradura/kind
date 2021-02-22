# frozen_string_literal: true

module Kind
  module Maybe
    class Result
      attr_reader :value

      Value = ->(arg) { arg.kind_of?(::Kind::Maybe::Result) ? arg.value : arg } # :nodoc:

      def initialize(arg)
        @value = Value.(arg)
      end

      def value_or(method_name = UNDEFINED, &block)
        raise NotImplementedError
      end

      def none?
        raise NotImplementedError
      end

      def some?; !none?; end

      def map(&fn)
        raise NotImplementedError
      end

      alias_method :map!, :map
      alias_method :then, :map
      alias_method :then!, :map

      def check(&fn)
        raise NotImplementedError
      end

      def try(method_name = UNDEFINED, &block)
        raise NotImplementedError
      end

      alias_method :try!, :try

      def dig(*keys)
        raise NotImplementedError
      end

      def presence
        raise NotImplementedError
      end
    end
  end
end
