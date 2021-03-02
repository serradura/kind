# frozen_string_literal: true

module Kind
  class Result::Monad
    require 'kind/result/monad/wrapper'

    attr_reader :type, :value

    def self.[](arg1 = UNDEFINED, arg2 = UNDEFINED) # :nodoc:
      type = UNDEFINED == arg2 ? self::DEFAULT_TYPE : KIND.of!(::Symbol, arg1)

      Error.wrong_number_of_args!(given: 0, expected: '1 or 2') if UNDEFINED == arg1

      value = UNDEFINED == arg2 ? arg1 : arg2

      new(type, value)
    end

    private_class_method :new

    def initialize(type, value)
      @type = type
      @value = value
    end

    def failure?
      false
    end

    def failed?
      failure?
    end

    def success?
      false
    end

    def succeeded?
      success?
    end

    def value_or(_method_name = UNDEFINED, &block)
      raise NotImplementedError
    end

    def map(&_)
      raise NotImplementedError
    end

    alias_method :then, :map

    def on_success(*types)
      yield(value) if success? && hook_type?(types)

      self
    end

    def on_failure(*types)
      yield(value) if failure? && hook_type?(types)

      self
    end

    def on
      monad = Wrapper.new(self)

      yield(monad)

      monad.output
    end

    def to_ary
      [type, value]
    end

    def ===(monad)
      self.class === monad && self.type == monad.type && self.value === monad.value
    end

    private

      def hook_type?(types)
        types.empty? || types.include?(type)
      end
  end
end
