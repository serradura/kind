# frozen_string_literal: true

module Kind
  class Result::Wrapper
    def initialize(result)
      @result = result
      @output = UNDEFINED
    end

    def failure(*types)
      return if @result.success? || output?

      @output = yield(@result.value) if result_type?(types)
    end

    def success(*types)
      return if @result.failure? || output?

      @output = yield(@result.value) if result_type?(types)
    end

    def output?
      UNDEFINED != @output
    end

    def output
      @output if output?
    end

    private

      def result_type?(types)
        types.empty? || types.include?(@result.type)
      end
  end
end
