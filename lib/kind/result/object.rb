# frozen_string_literal: true

module Kind
  class Result::Object
    attr_reader :type, :value

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
      result = Result::Wrapper.new(self)

      yield(result)

      result.output
    end

    def to_ary
      [type, value]
    end

    private

      def hook_type?(types)
        types.empty? || types.include?(type)
      end
  end
end
