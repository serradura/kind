# frozen_string_literal: true

module Kind
  module BasicObject
    def [](value, label: nil)
      STRICT.object_is_a(self, value, label)
    end

    def or_nil(value)
      return value if self === value
    end

    def or_undefined(value)
      or_nil(value) || Undefined
    end

    def or(fallback, value = UNDEFINED)
      return __or_func.(fallback) if UNDEFINED === value

      self === value ? value : fallback
    end

    def value?(value = UNDEFINED)
      return self === value if UNDEFINED != value

      @__is_value ||= ->(tc) { ->(arg) { tc === arg } }.(self)
    end

    def value(arg, default:)
      KIND.value(self, arg, self[default])
    end

    def or_null(value) # :nodoc:
      KIND.nil_or_undefined?(value) ? value : self[value]
    end

    private

      def __or_func
        @__or_func ||= ->(tc, fb, value) { tc === value ? value : tc.or_null(fb) }.curry[self]
      end
  end
end
