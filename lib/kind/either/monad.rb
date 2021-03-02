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

    def on_right
      yield(value) if right?

      self
    end

    def on_left
      yield(value) if left?

      self
    end

    def on
      monad = Wrapper.new(self)

      yield(monad)

      monad.output
    end

    def ===(monad)
      self.class === monad && self.value === monad.value
    end
  end
end
