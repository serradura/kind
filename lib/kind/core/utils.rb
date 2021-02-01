# frozen_string_literal: true

module Kind
  module Core::Utils
    def self.nil_or_undefined?(value) # :nodoc:
      value.nil? || Undefined == value
    end

    def self.kind?(of:, by:) # :nodoc:
      of.empty? ? by : of.all?(&by)
    end

    def self.kind_of?(kind, values)
      kind?(of: values, by: -> value {
        value.kind_of?(kind)
      })
    end

    def self.kind_error!(kind_name, value) # :nodoc:
      raise Kind::Error.new(kind_name, value)
    end

    def self.kind_of!(kind, value, kind_name = nil) # :nodoc:
      return value if kind === value

      kind_error!(kind_name || kind.name, value)
    end

    def self.kind_of_class?(value) # :nodoc:
      value.kind_of?(::Class)
    end

    def self.kind_of_module?(value) # :nodoc:
      ::Module == value || (value.is_a?(::Module) && !kind_of_class?(value))
    end

    def self.kind_of_module_or_class!(value) # :nodoc:
      kind_of!(::Module, value, 'Module/Class')
    end

    def self.kind_respond_to!(method_name, value) # :nodoc:
      return value if value.respond_to?(method_name)

      raise ::Kind::Error.new("Expected #{value} to respond to #{method_name}")
    end

    def self.kind_is?(expected, value) # :nodoc:
      is_kind(kind_of_module_or_class!(expected), value)
    end

    def self.is_kind(expected_kind, value) # :nodoc:
      kind = kind_of_module_or_class!(value)

      if kind_of_class?(kind)
        kind <= expected_kind || expected_kind == ::Class
      else
        kind == expected_kind || kind.kind_of?(expected_kind)
      end
    end
  end
end
