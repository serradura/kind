# frozen_string_literal: true

module Kind
  module Is
    def self.call(expected, object)
      DEPRECATION.warn_method_replacement('Kind::Is.call', 'Kind::KIND.is?')

      KIND.is?(expected, object)
    end

    def self.Class(value)
      DEPRECATION.warn_method_replacement('Kind::Is.Class', 'Kind.of_class?')

      Kind.of_class?(value)
    end

    def self.Module(value)
      DEPRECATION.warn_method_replacement('Kind::Is.Module', 'Kind.of_module?')

      Kind.of_module?(value)
    end

    def self.Boolean(value)
      DEPRECATION.warn_removal('Kind::Is.Boolean')

      Kind::Class[value] <= TrueClass || value <= FalseClass
    end

    def self.Callable(value)
      DEPRECATION.warn_method_replacement('Kind::Is.Callable', 'Kind::Callable?')

      value.respond_to?(:call)
    end
  end
end
