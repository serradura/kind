# frozen_string_literal: true

module Kind
  require 'kind/basic/monad_wrapper'

  class Result::Monad::Wrapper < MonadWrapper
    def failure(*types)
      return if @monad.success? || output?

      @output = yield(@monad.value) if result_type?(types)
    end

    def success(*types)
      return if @monad.failure? || output?

      @output = yield(@monad.value) if result_type?(types)
    end

    private

      def result_type?(types)
        types.empty? || types.include?(@monad.type)
      end
  end
end
