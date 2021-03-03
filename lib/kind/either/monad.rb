# frozen_string_literal: true

module Kind
  class Either::Monad
    require 'kind/either/monad/wrapper'

    attr_reader :value

    singleton_class.send(:alias_method, :[], :new)

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

    def on
      monad = Wrapper.new(self)

      yield(monad)

      monad.output
    end

    def on_right(matcher = UNDEFINED)
      yield(value) if right? && either?(matcher)

      self
    end

    def on_left(matcher = UNDEFINED)
      yield(value) if left? && either?(matcher)

      self
    end

    def either?(matcher)
      UNDEFINED == matcher || matcher === value
    end

    def ===(monad)
      self.class === monad && self.value === monad.value
    end
  end
end
