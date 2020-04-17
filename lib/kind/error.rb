# frozen_string_literal: true

module Kind
  class Error < TypeError
    def initialize(kind_name, object)
      super("#{object.inspect} expected to be a kind of #{kind_name}")
    end
  end
end
