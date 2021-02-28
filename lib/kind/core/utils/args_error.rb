# frozen_string_literal: true

module Kind
  module ARGS_ERROR
    def self.wrong_number!(given:, expected:)
      raise ArgumentError, "wrong number of arguments (given #{given}, expected #{expected})"
    end

    INVALID_DEFAULT_ARG = 'the default value must be defined as an argument or block'.freeze

    def self.invalid_default!
      raise ArgumentError, INVALID_DEFAULT_ARG
    end

    private_constant :INVALID_DEFAULT_ARG
  end

  private_constant :ARGS_ERROR
end
