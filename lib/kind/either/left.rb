# frozen_string_literal: true

module Kind
  class Either::Left < Either::Monad
    def left?
      true
    end

    def value_or(default = UNDEFINED, &block)
      Error.invalid_default_arg! if UNDEFINED == default && !block

      UNDEFINED != default ? default : block.call(value)
    end

    def map(&_)
      self
    end

    alias_method :map!, :map
    alias_method :then, :map
    alias_method :then!, :map
    alias_method :and_then, :map
    alias_method :and_then!, :map

    def inspect
      '#<%s value=%p>' % ['Kind::Left', value]
    end
  end
end
