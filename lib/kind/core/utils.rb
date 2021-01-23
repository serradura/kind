# frozen_string_literal: true

module Kind
  module Core::Utils
    def self.kind(of:, by:)
      of.empty? ? by : of.all?(&by)
    end

    def self.kind_of?(kind, values)
      kind(of: values, by: -> value {
        value.kind_of?(kind)
      })
    end
  end
end
