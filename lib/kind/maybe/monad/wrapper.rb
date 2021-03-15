# frozen_string_literal: true

module Kind
  require 'kind/monad'

  class Maybe::Monad::Wrapper < Kind::Monad::Wrapper
    def none(matcher = UNDEFINED)
      return if @monad.some? || output?

      @output = yield(@monad.value) if @monad.maybe?(matcher)
    end

    def some(matcher = UNDEFINED)
      return if @monad.none? || output?

      @output = yield(@monad.value) if @monad.maybe?(matcher)
    end
  end
end
