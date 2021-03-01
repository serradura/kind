# frozen_string_literal: true

module Kind
  require 'kind/basic/monad_wrapper'

  class Result::Wrapper < MonadWrapper
    def failure(*types)
      return if @result.success? || output?

      @output = yield(@result.value) if result_type?(types)
    end

    def success(*types)
      return if @result.failure? || output?

      @output = yield(@result.value) if result_type?(types)
    end

    private

      def result_type?(types)
        types.empty? || types.include?(@result.type)
      end
  end
end
