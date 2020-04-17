# frozen_string_literal: true

module Kind
  module Is
    def self.call(expected, object)
      __call__(Kind::Of.Module(expected), object)
    end

    def self.__call__(expected_kind, object)
      kind = Kind::Of.Module(object)

      kind <= expected_kind || false
    end
  end
end
