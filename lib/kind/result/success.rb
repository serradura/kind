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
      map!(&fn)
    rescue Kind::Monad::Error => e
      raise e
    rescue StandardError => e
      Result::Failure[:exception, e]
    end

    def map!(&fn)
      monad = fn.call(@value)

      return monad if Result::Monad === monad

      raise Kind::Monad::Error.new('Kind::Success | Kind::Failure', monad)
    end

    alias_method :then, :map
    alias_method :then!, :map!
    alias_method :and_then, :map
    alias_method :and_then!, :map!

    def inspect
      '#<%s type=%p value=%p>' % ['Kind::Success', type, value]
    end
  end
end
