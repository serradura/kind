# frozen_string_literal: true

module Kind
  require 'kind/basic/monad_wrapper'

  module Maybe
    class Monad::Wrapper < MonadWrapper
      def none
        return if @monad.some? || output?

        @output = yield(@monad.value)
      end

      def some
        return if @monad.none? || output?

        @output = yield(@monad.value)
      end
    end
  end
end
