# frozen_string_literal: true

module Kind
  module CheckerUtils
    def self.kind_of?(kind, values)
      if values.empty?
        -> value { value.kind_of?(kind) }
      else
        values.all? { |value| value.kind_of?(kind) }
      end
    end
  end
end
