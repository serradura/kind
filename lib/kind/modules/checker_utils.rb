# frozen_string_literal: true

module Kind
  module CheckerUtils
    def self.kind_of_by(fn:, values:)
      values.empty? ? fn : values.all?(&fn)
    end

    def self.kind_of?(kind, values)
      kind_of_by(
        fn: -> value { value.kind_of?(kind) },
        values: values
      )
    end
  end
end
