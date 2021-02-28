# frozen_string_literal: true

module Kind
  class Either::Result::Wrapper
    def initialize(result)
      @result = result
      @output = UNDEFINED
    end

    def left
      return if @result.right? || output?

      @output = yield(@result.value)
    end

    def right
      return if @result.left? || output?

      @output = yield(@result.value)
    end

    def output?
      UNDEFINED != @output
    end

    def output
      @output if output?
    end
  end
end
