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

    def map(&fn)
      monad = fn.call(@value)

      return monad if Result::Monad === monad

      KIND.error!('Kind::Success | Kind::Failure', monad)
    end

    alias_method :then, :map

    def inspect
      '#<%s value=%s>' % ['Kind::Success', value]
    end
  end
end
