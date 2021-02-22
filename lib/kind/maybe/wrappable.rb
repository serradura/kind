# frozen_string_literal: true

module Kind
  module Maybe
    module Wrappable
      def wrap(arg = UNDEFINED)
        if block_given?
          begin
            return new(yield) if UNDEFINED == arg

            input = __call_before_expose_the_arg_in_a_block(arg)

            input.kind_of?(Maybe::None) ? input : new(yield(input))
          rescue StandardError => exception
            Maybe.__none__(exception)
          end
        else
          return new(arg) if UNDEFINED != arg

          WRONG_NUMBER_OF_ARGS.error!(given: 0, expected: 1)
        end
      end

      private

        def __call_before_expose_the_arg_in_a_block(input)
          input
        end
    end

    private_constant :Wrappable
  end
end
