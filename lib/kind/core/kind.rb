# frozen_string_literal: true

module Kind
  module KIND
    def self.null?(value) # :nodoc:
      value.nil? || Undefined == value
    end

    def self.of?(kind, values) # :nodoc:
      of_kind = -> value { kind === value }

      values.empty? ? of_kind : values.all?(&of_kind)
    end

    def self.of!(kind, value, kind_name = nil) # :nodoc:
      return value if kind === value

      error!(kind_name || kind.name, value)
    end

    def self.error!(kind_name, value) # :nodoc:
      raise Error.new(kind_name, value)
    end

    def self.of_class?(value) # :nodoc:
      value.kind_of?(::Class)
    end

    def self.of_module?(value) # :nodoc:
      ::Module == value || (value.is_a?(::Module) && !of_class?(value))
    end

    def self.of_module_or_class!(value) # :nodoc:
      of!(::Module, value, 'Module/Class')
    end

    def self.respond_to!(method_name, value) # :nodoc:
      return value if value.respond_to?(method_name)

      raise Error.new("expected #{value} to respond to :#{method_name}")
    end

    def self.is?(expected, value) # :nodoc:
      is!(of_module_or_class!(expected), value)
    end

    def self.is!(expected_kind, value) # :nodoc:
      kind = of_module_or_class!(value)

      if of_class?(kind)
        kind <= expected_kind || expected_kind == ::Class
      else
        kind == expected_kind || kind.kind_of?(expected_kind)
      end
    end

    def self.value(kind, arg, default) # :nodoc:
      kind === arg ? arg : default
    end
  end
end
