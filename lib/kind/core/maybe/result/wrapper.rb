# frozen_string_literal: true

module Kind
  require 'kind/basic/monad_wrapper'

  module Maybe
    class Result::Wrapper < MonadWrapper
      def none
        return if @result.some? || output?

        @output = yield(@result.value)
      end

      def some
        return if @result.none? || output?

        @output = yield(@result.value)
      end
    end
  end
end
