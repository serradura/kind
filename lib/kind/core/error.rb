# frozen_string_literal: true

module Kind
  class Error < TypeError
    def initialize(arg, object = UNDEFINED, label: nil)
      if UNDEFINED == object
        # Will be used when the exception was raised with a message. e.g:
        # raise Kind::Error, "some message"
        super(arg)
      else
        label_text = label ? "#{label}: " : label

        super("#{label_text}#{object.inspect} expected to be a kind of #{arg}")
      end
    end
  end
end
