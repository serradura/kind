# frozen_string_literal: true

module Kind
  module Core::Checker
    def __kind_name__
      __kind__.name
    end

    def instance?(value)
      __kind__ === value
    end

    def or_nil(value)
      return value if instance?(value)
    end

    def or_undefined(value)
      or_nil(value) || Undefined
    end

    def [](value)
      return value if instance?(value)

      Core::Utils.kind_error!(__kind_name__, value)
    end
  end
end
