# frozen_string_literal: true

module Kind
  module Maybe
    class Monad
      require 'kind/maybe/monad/wrapper'

      attr_reader :value

      Value = ->(arg) { arg.kind_of?(Maybe::Monad) ? arg.value : arg } # :nodoc:

      def initialize(value)
        @value = Value[value]
      end

      def value_or(_method_name = UNDEFINED, &block)
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
      alias_method :and_then, :map
      alias_method :and_then!, :map!

      def check(&fn)
        raise NotImplementedError
      end

      alias_method :accept, :check
      alias_method :reject, :check

      def try(_method_name = UNDEFINED, &block)
        raise NotImplementedError
      end

      alias_method :try!, :try

      def dig(*keys)
        raise NotImplementedError
      end

      def presence
        raise NotImplementedError
      end

      def on
        monad = Wrapper.new(self)

        yield(monad)

        monad.output
      end

      def on_some(matcher = UNDEFINED)
        yield(value) if some? && maybe?(matcher)

        self
      end

      def on_none(matcher = UNDEFINED)
        yield(value) if none? && maybe?(matcher)

        self
      end

      def maybe?(matcher)
        UNDEFINED == matcher || matcher === value
      end
    end
  end
end
