# frozen_string_literal: true

module Kind
  module Monad
    Error = ::Class.new(Kind::Error)

    class Wrapper
      def initialize(monad)
        @monad = monad
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
end
