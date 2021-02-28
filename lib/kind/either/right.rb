# frozen_string_literal: true

module Kind
  class Either::Right < Either::Result
    def right?
      true
    end

    def value_or(_default = UNDEFINED, &block)
      @value
    end

    def map(&fn)
      result = fn.call(@value)

      return result if Either::Result === result

      KIND.error!('Kind::Right | Kind::Left', result)
    end

    alias_method :then, :map

    def inspect
      '#<%s value=%s>' % ['Kind::Right', value]
    end
  end
end
