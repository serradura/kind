# frozen_string_literal: true

module Kind
  class Either::Right < Either::Monad
    def right?
      true
    end

    def value_or(_default = UNDEFINED, &block)
      @value
    end

    def map(&fn)
      monad = fn.call(@value)

      return monad if Either::Monad === monad

      KIND.error!('Kind::Right | Kind::Left', monad)
    end

    alias_method :then, :map

    def inspect
      '#<%s value=%s>' % ['Kind::Right', value]
    end
  end
end
