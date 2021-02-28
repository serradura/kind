# frozen_string_literal: true

module Kind
  class Either::Result
    require 'kind/either/result/wrapper'

    attr_reader :value

    def initialize(value)
      @value = value
    end

    def left?
      false
    end

    def right?
      false
    end

    def value_or(_method_name = UNDEFINED, &block)
      raise NotImplementedError
    end

    def map(&_)
      raise NotImplementedError
    end

    alias_method :then, :map

    def on_right
      yield(value) if right?

      self
    end

    def on_left
      yield(value) if left?

      self
    end

    def on
      result = Wrapper.new(self)

      yield(result)

      result.output
    end
  end
end
