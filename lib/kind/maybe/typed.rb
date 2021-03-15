# frozen_string_literal: true

module Kind
  module Maybe
    class Typed
      include Wrapper

      singleton_class.send(:alias_method, :[], :new)

      def initialize(kind)
        @kind = kind
      end

      def new(arg)
        value = Monad::Value[arg]

        @kind === value ? Maybe::Some[value] : Maybe::NONE_INSTANCE
      end

      alias_method :[], :new

      def inspect
        "Kind::Maybe<#{@kind}>"
      end

      private

        def __call_before_expose_the_arg_in_a_block(arg)
          value = Monad::Value[arg]

          @kind === value ? value : Maybe::NONE_INSTANCE
        end
    end
  end
end
