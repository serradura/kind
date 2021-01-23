# frozen_string_literal: true

module Kind
  module Is
    def self.call(expected, object)
      warn "[DEPRECATION] `Kind::Is.call` is deprecated. Please use `Kind::Core::Utils.kind_is?` instead."
      Core::Utils.kind_is?(expected, object)
    end

    def self.Class(value)
      warn "[DEPRECATION] `Kind::Is.Class` is deprecated. Please use `Kind.of_class?` instead."
      Kind.of_class?(value)
    end

    def self.Module(value)
      warn "[DEPRECATION] `Kind::Is.Module` is deprecated. Please use `Kind.of_module?` instead."
      Kind.of_module?(value)
    end

    def self.Boolean(value)
      warn "[DEPRECATION] `Kind::Is.Boolean` is deprecated. It will be removed in the next major version."
      Kind::Class[value] <= TrueClass || value <= FalseClass
    end

    def self.Callable(value)
      warn "[DEPRECATION] `Kind::Is.Callable` is deprecated. Please use `Kind::Callable?` instead."
      value.respond_to?(:call)
    end
  end
end
