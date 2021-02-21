# frozen_string_literal: true

module Kind
  class Error < TypeError
    def initialize(arg, object = UNDEFINED)
      if UNDEFINED == object
        # Will be used when the exception was raised with a message. e.g:
        # raise Kind::Error, "some message"
        super(arg)
      else
        super("#{object.inspect} expected to be a kind of #{arg}")
      end
    end
  end
end
