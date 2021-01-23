# frozen_string_literal: true

require 'singleton'

module Kind
  class Checker
    class Factory
      include Singleton

      def self.create(kind)
        instance.create(kind)
      end

      def initialize
        @__checkers__ = {}
      end

      def create(kind)
        @__checkers__[kind] ||= begin
          kind_name = kind.name

          if Kind::Of.const_defined?(kind_name, false)
            Kind::Of.const_get(kind_name)
          else
            Kind::Checker.new(Kind.of_module_or_class!(kind))
          end
        end
      end
    end
  end
end
