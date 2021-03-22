# frozen_string_literal: true

module Kind
  class Result::Success < Result::Monad
    DEFAULT_TYPE = :ok

    def success?
      true
    end

    def value_or(_default = UNDEFINED, &block)
      @value
    end

    def map(callable = UNDEFINED, &fn)
      _resolve_map(callable, fn)
    rescue Kind::Monad::Error => e
      raise e
    rescue StandardError => e
      Result::Failure[:exception, e]
    end

    alias_method :then, :map
    alias_method :and_then, :map

    def map!(callable = UNDEFINED, &fn)
      _resolve_map(callable, fn)
    end

    alias_method :|, :map!
    alias_method :>>, :map!
    alias_method :then!, :map!
    alias_method :and_then!, :map!

    def inspect
      '#<%s type=%p value=%p>' % ['Kind::Success', type, value]
    end

    private

      def _resolve_map(callable, fn)
        callable.respond_to?(:call) ? _map(callable) : _map(fn)
      end

      def _map(fn)
        monad = fn.call(@value)

        return monad if Result::Monad === monad

        raise Kind::Monad::Error.new('Kind::Success | Kind::Failure', monad)
      end
  end
end
