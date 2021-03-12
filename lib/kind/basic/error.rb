# frozen_string_literal: true

module Kind
  class Error < StandardError
    INVALID_DEFAULT_ARG = 'the default value must be defined as an argument or block'.freeze

    def self.wrong_number_of_args!(given:, expected:)
      raise ArgumentError, "wrong number of arguments (given #{given}, expected #{expected})"
    end

    def self.invalid_default_arg!
      raise ArgumentError, INVALID_DEFAULT_ARG
    end

    def initialize(arg, object = UNDEFINED, label: nil)
      if UNDEFINED == object
        # Will be used when the exception was raised with a message. e.g:
        # raise Kind::Error, "some message"
        super(arg)
      else
        label_text = label ? "#{label}: " : ''

        super("#{label_text}#{object.inspect} expected to be a kind of #{arg}")
      end
    end

    private_constant :INVALID_DEFAULT_ARG
  end
end
