# frozen_string_literal: true

module Kind
  class Result::Failure < Result::Monad
    DEFAULT_TYPE = :error

    def failure?
      true
    end

    def value_or(default = UNDEFINED, &block)
      Error.invalid_default_arg! if UNDEFINED == default && !block

      UNDEFINED != default ? default : block.call(value)
    end

    def map(_ = UNDEFINED, &_fn)
      self
    end

    alias_method :|, :map
    alias_method :>>, :map
    alias_method :map!, :map
    alias_method :then, :map
    alias_method :then!, :map
    alias_method :and_then, :map
    alias_method :and_then!, :map

    def inspect
      '#<%s type=%p value=%p>' % ['Kind::Failure', type, value]
    end
  end
end
