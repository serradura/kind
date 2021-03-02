# frozen_string_literal: true

module Kind
  require 'kind/basic/monad_wrapper'

  class Either::Monad::Wrapper < MonadWrapper
    def left
      return if @monad.right? || output?

      @output = yield(@monad.value)
    end

    def right
      return if @monad.left? || output?

      @output = yield(@monad.value)
    end
  end
end
