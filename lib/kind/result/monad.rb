# frozen_string_literal: true

module Kind
  class Result::Monad
    include Result::Abstract

    require 'kind/empty'
    require 'kind/result/monad/wrapper'

    attr_reader :type, :value

    def self.[](arg1 = UNDEFINED, arg2 = UNDEFINED, opt = Empty::HASH) # :nodoc:
      value_must_be_a = opt[:value_must_be_a]

      type = UNDEFINED == arg2 ? self::DEFAULT_TYPE : STRICT.kind_of(::Symbol, arg1)

      Error.wrong_number_of_args!(given: 0, expected: '1 or 2') if UNDEFINED == arg1

      value = UNDEFINED == arg2 ? arg1 : arg2

      new(type, (value_must_be_a ? STRICT.kind_of(value_must_be_a, value) : value))
    end

    private_class_method :new

    def initialize(type, value)
      @type = type
      @value = value
    end

    def value_or(_method_name = UNDEFINED, &block)
      raise NotImplementedError
    end

    def map(_ = UNDEFINED, &_fn)
      raise NotImplementedError
    end

    alias_method :|, :map
    alias_method :>>, :map
    alias_method :map!, :map
    alias_method :then, :map
    alias_method :then!, :map
    alias_method :and_then, :map
    alias_method :and_then!, :map

    def on
      monad = Wrapper.new(self)

      yield(monad)

      monad.output
    end

    def on_success(types = Undefined, matcher = Undefined)
      yield(value) if success? && result?(types, matcher)

      self
    end

    def on_failure(types = Undefined, matcher = Undefined)
      yield(value) if failure? && result?(types, matcher)

      self
    end

    def ===(m)
      return false unless Result::Abstract === m
      return false unless (self.success? && m.success?) || (self.failure? && m.failure?)

      self.type == m.type && self.value === m.value
    end
  end
end
