# frozen_string_literal: true

module Kind
  class Result::Success < Result::Object
    def success?
      true
    end

    def value_or(_default = UNDEFINED, &block)
      @value
    end

    def map(&fn)
      result = fn.call(@value)

      return result if Result::Object === result

      KIND.error!('Kind::Success | Kind::Failure', result)
    end

    alias_method :then, :map

    def inspect
      '#<%s value=%s>' % ['Kind::Success', value]
    end
  end
end
