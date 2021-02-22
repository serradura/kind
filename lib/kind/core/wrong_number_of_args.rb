# frozen_string_literal: true

module Kind
  module WRONG_NUMBER_OF_ARGS
    def self.error!(given:, expected:)
      raise ArgumentError, "wrong number of arguments (given #{given}, expected #{expected})"
    end
  end
end
