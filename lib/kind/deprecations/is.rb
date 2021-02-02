# frozen_string_literal: true

module Kind
  module Is
    def self.call(expected, object)
      ::Kind::Deprecation.warn_method_replacement('Kind::Is.call', 'Kind::Core::Utils.kind_is?')

      Core::Utils.kind_is?(expected, object)
    end

    def self.Class(value)
      ::Kind::Deprecation.warn_method_replacement('Kind::Is.Class', 'Kind.of_class?')

      Kind.of_class?(value)
    end

    def self.Module(value)
      ::Kind::Deprecation.warn_method_replacement('Kind::Is.Module', 'Kind.of_module?')

      Kind.of_module?(value)
    end

    def self.Boolean(value)
      ::Kind::Deprecation.warn_removal('Kind::Is.Boolean')

      Kind::Class[value] <= TrueClass || value <= FalseClass
    end

    def self.Callable(value)
      ::Kind::Deprecation.warn_method_replacement('Kind::Is.Callable', 'Kind::Callable?')

      value.respond_to?(:call)
    end
  end
end
