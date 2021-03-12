# frozen_string_literal: true

module Kind
  module NotNil
    def self.[](value, label: nil)
      return value unless value.nil?

      label_text = label ? "#{label}: " : ''

      raise Error.new("#{label_text}expected to not be nil")
    end
  end
end
