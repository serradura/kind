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
    rescue Kind::Monad::WrongOutput => e
      raise e
    rescue StandardError => e
      Either::Left[e]
    end

    def map!(&fn)
      monad = fn.call(@value)

      return monad if Either::Monad === monad

      raise Kind::Monad::WrongOutput.new('Kind::Right | Kind::Left', monad)
    end

    alias_method :then, :map
    alias_method :then!, :map!

    def inspect
      '#<%s value=%s>' % ['Kind::Right', value]
    end
  end
end
