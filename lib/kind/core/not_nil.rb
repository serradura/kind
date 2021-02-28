# frozen_string_literal: true

module Kind
  module NotNil
    def self.[](value)
      return value unless value.nil?

      raise Error.new('expected to not be nil')
    end
  end
end
