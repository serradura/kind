# frozen_string_literal: true

module Kind
  class Result::Failure < Result::Object
    def failure?
      true
    end

    def value_or(default = UNDEFINED, &block)
      ARGS_ERROR.invalid_default! if UNDEFINED == default && !block

      UNDEFINED != default ? default : block.call
    end

    def map(&_)
      self
    end

    alias_method :then, :map

    def inspect
      '#<%s value=%s>' % ['Kind::Failure', value]
    end
  end
end
