# frozen_string_literal: true

module Kind
  class Optional
    self.singleton_class.send(:alias_method, :[], :new)

    IsNone = -> value { value == nil || value == Undefined }

    attr_reader :value

    def initialize(arg)
      @value = arg.is_a?(Kind::Optional) ? arg.value : arg
    end

    INVALID_DEFAULT_ARG = 'the default value must be defined as an argument or block'.freeze

    def value_or(default = Undefined, &block)
      return @value if some?

      if default == Undefined && !block
        raise ArgumentError, INVALID_DEFAULT_ARG
      else
        IsNone.(default) ? block.call : default
      end
    end

    def none?
      @none ||= IsNone.(@value)
    end

    def some?
      !none?
    end

    def map(&fn)
      return self if none?

      self.class.new(fn.call(@value))
    end

    alias_method :then, :map

    def try(method_name = Undefined, &block)
      fn = method_name == Undefined ? block : Kind.of.Symbol(method_name).to_proc

      unless IsNone.(value)
        result = fn.call(value)

        return result unless IsNone.(result)
      end
    end

    private_constant :IsNone, :INVALID_DEFAULT_ARG
  end
end
