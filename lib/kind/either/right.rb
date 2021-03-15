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
      map!(&fn)
    rescue Kind::Monad::Error => e
      raise e
    rescue StandardError => e
      Either::Left[e]
    end

    def map!(&fn)
      monad = fn.call(@value)

      return monad if Either::Monad === monad

      raise Kind::Monad::Error.new('Kind::Right | Kind::Left', monad)
    end

    alias_method :then, :map
    alias_method :then!, :map!
    alias_method :and_then, :map
    alias_method :and_then!, :map!

    def inspect
      '#<%s value=%p>' % ['Kind::Right', value]
    end
  end
end
