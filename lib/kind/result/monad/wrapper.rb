# frozen_string_literal: true

module Kind
  require 'kind/monad'

  class Result::Monad::Wrapper < Kind::Monad::Wrapper
    def failure(types = Undefined, matcher = Undefined)
      return if @monad.success? || output?

      @output = yield(@monad.value) if @monad.result?(types, matcher)
    end

    def success(types = Undefined, matcher = Undefined)
      return if @monad.failure? || output?

      @output = yield(@monad.value) if @monad.result?(types, matcher)
    end
  end
end
