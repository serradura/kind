# frozen_string_literal: true

module Kind
  class MonadWrapper
    def initialize(result)
      @result = result
      @output = UNDEFINED
    end

    def output?
      UNDEFINED != @output
    end

    def output
      @output if output?
    end
  end
end
