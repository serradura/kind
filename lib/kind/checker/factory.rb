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

      MODULE_OR_CLASS = 'Module/Class'.freeze

      private_constant :MODULE_OR_CLASS

      def create(kind)
        @__checkers__[kind] ||= begin
          kind_name = kind.name

          if Kind::Of.const_defined?(kind_name, false)
            Kind::Of.const_get(kind_name)
          else
            Kind::Checker.new(Kind::Of.(::Module, kind, MODULE_OR_CLASS))
          end
        end
      end
    end
  end
end
