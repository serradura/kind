# frozen_string_literal: true

require 'kind/version'

module Kind
  class Error < TypeError
    def initialize(klass, object)
      super("#{object} expected to be a kind of #{klass}")
    end
  end

  module Of
    def self.call(klass, object)
      return object if object.is_a?(klass)

      raise Kind::Error.new(klass, object)
    end

    def self.Class(object)
      self.call(::Class, object)
    end
  end

  module Is
    def self.call(expected, value)
      expected_klass, klass = Kind.of.Class(expected), Kind.of.Class(value)

      klass <= expected_klass
    end
  end

  def self.of; Of; end
  def self.is; Is; end

  singleton_class.send(:alias_method, :is_a, :is)

  module Types
    KIND_OF = <<-RUBY
      def self.%{klass}(object = nil)
        return Kind::Of::%{klass} unless object

        Kind::Of.call(::%{klass}, object)
      end
    RUBY

    KIND_IS = <<-RUBY
      def self.%{klass}(value)
        Kind::Is.call(::%{klass}, value)
      end
    RUBY

    KIND_OF_MODULE = <<-RUBY
      def self.class?(value)
        Kind::Is.call(::%{klass}, value)
      end

      def self.instance?(value)
        value.is_a?(::%{klass})
      end

      def self.or_nil(value)
        return value if instance?(value)
      end
    RUBY

    private_constant :KIND_OF, :KIND_IS, :KIND_OF_MODULE

    def self.add(klass)
      klass_name = Kind.of.Class(klass).name

      return if Of.respond_to?(klass_name)

      Of.instance_eval(KIND_OF % { klass: klass_name })

      type_module = Module.new
      type_module.instance_eval(KIND_OF_MODULE % { klass: klass_name })

      Of.const_set(klass_name, type_module)

      return if Is.respond_to?(klass_name)

      Is.instance_eval(KIND_IS % { klass: klass_name })
    end
  end

  [Hash, String]
    .each { |klass| Types.add(klass) }
end
