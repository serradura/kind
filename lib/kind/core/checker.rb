# frozen_string_literal: true

module Kind
  module Core::Checker
    def __kind_name__
      __kind__.name
    end

    def instance?(value)
      value.kind_of?(__kind__)
    end

    def [](value)
      ::Kind::Of.(__kind__, value, __kind_name__)
    end

    def or_nil(value)
      return value if instance?(value)
    end

    def or_undefined(value)
      or_nil(value) || Undefined
    end
  end
end
