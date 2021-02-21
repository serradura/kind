# frozen_string_literal: true

module Kind
  module Maybe
    module Wrappable
      WRONG_NUMBER_OF_ARGS = 'wrong number of arguments (given 0, expected 1)'.freeze

      def wrap(arg = UNDEFINED)
        if block_given?
          begin
            new(UNDEFINED == arg ? yield : yield(arg))
          rescue StandardError => exception
            Maybe.__none__(exception)
          end
        else
          return new(arg) if UNDEFINED != arg

          raise ArgumentError, WRONG_NUMBER_OF_ARGS
        end
      end
    end

    private_constant :Wrappable
  end
end
