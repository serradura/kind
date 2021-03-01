# frozen_string_literal: true

module Kind
  require 'kind/basic/monad_wrapper'

  class Either::Result::Wrapper < MonadWrapper
    def left
      return if @result.right? || output?

      @output = yield(@result.value)
    end

    def right
      return if @result.left? || output?

      @output = yield(@result.value)
    end
  end
end
