# frozen_string_literal: true

module Kind
  module ACTION_STEPS
    private

      def Check(mthod); ->(value) { __Check(thod, value) }; end
      def Step(mthod); ->(value) { __Step(mthod, value) }; end
      def Map(mthod); ->(value) { __Map(mthod, value) }; end
      def Tee(mthod); ->(value) { __Tee(mthod, value) }; end
      def Try(mthod, opt = Empty::HASH)
        ->(value) { __Try(mthod, value, opt) }
      end

      def Check!(mthod, value); __Check(mthod, value); end
      def Step!(mthod, value); __Step(mthod, value); end
      def Map!(mthod, value); __Map(mthod, value); end
      def Tee!(mthod, value); __Tee(mthod, value); end
      def Try!(mthod, value, opt = Empty::HASH); __Try(mthod, value, opt); end

      def __Check(mthod, value) # :nodoc:
        __resolve_step(mthod, value) ? Success(mthod, value) : Failure(mthod, value)
      end

      def __Step(mthod, value) # :nodoc:
        __resolve_step(mthod, value)
      end

      def __Map(mthod, value) # :nodoc:
        Success(mthod, __resolve_step(mthod, value))
      end

      def __Tee(mthod, value) # :nodoc:
        __resolve_step(mthod, value)

        Success(mthod, value)
      end

      def __Try(mthod, value, opt = Empty::HASH) # :nodoc:
        begin
          Success(mthod, __resolve_step(mthod, value))
        rescue opt.fetch(:catch, StandardError) => e
          Failure(mthod, __map_step_exception(e))
        end
      end

      def __resolve_step(mthod, value) # :nodoc:
        send(mthod, value)
      end

      def __map_step_exception(value) # :nodoc:
        value
      end
  end

  private_constant :ACTION_STEPS
end
