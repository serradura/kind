# frozen_string_literal: true

module Kind
  module Of
    def self.call(klass, object, name: nil)
      return object if object.is_a?(klass)

      raise Kind::Error.new((name || klass.name), object)
    end

    def self.Class(object = Undefined)
      return Class if object == Undefined

      self.call(::Class, object)
    end

    const_set(:Class, ::Module.new do
      extend Checker

      def self.__kind; ::Class; end

      def self.class?(value); Kind::Is.Class(value); end

      def self.instance?(value); class?(value); end
    end)

    def self.Module(object = Undefined)
      return Module if object == Undefined

      self.call(::Module, object)
    end

    const_set(:Module, ::Module.new do
      extend Checker

      def self.__kind; ::Module; end

      def self.class?(value); Kind::Is.Module(value); end

      def self.instance?(value); class?(value); end
    end)
  end
end
