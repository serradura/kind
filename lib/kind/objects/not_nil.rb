# frozen_string_literal: true

module Kind
  module NotNil
    def self.[](value, label: nil)
      STRICT.not_nil(value, label)
    end
  end
end
