# frozen_string_literal: true

module Kind
  module Core::Checker
    def name
      kind.name
    end

    def instance?(value)
      kind === value
    end

    def or_nil(value)
      return value if instance?(value)
    end

    def or_undefined(value)
      or_nil(value) || Undefined
    end

    def [](value)
      return value if instance?(value)

      Core::Utils.kind_error!(name, value)
    end
  end
end
