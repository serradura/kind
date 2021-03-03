# frozen_string_literal: true

module Kind
  require 'kind/basic/monad'

  class Either::Monad::Wrapper < Kind::Monad::Wrapper
    def left(matcher = UNDEFINED)
      return if @monad.right? || output?

      @output = yield(@monad.value) if @monad.either?(matcher)
    end

    def right(matcher = UNDEFINED)
      return if @monad.left? || output?

      @output = yield(@monad.value) if @monad.either?(matcher)
    end
  end
end
