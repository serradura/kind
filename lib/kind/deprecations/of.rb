# frozen_string_literal: true

module Kind
  module Of
    def self.call(kind, object, kind_name = nil)
      ::Kind::Deprecation.warn_method_replacement('Kind::Of.call', 'Kind::Core::Utils.kind_of!')

      Core::Utils.kind_of!(kind, object, kind_name)
    end

    # -- Class

    def self.Class(object = Undefined)
      ::Kind::Deprecation.warn_method_replacement('Kind::Of::Class', 'Kind::Class')

      return Class if Undefined == object

      self.call(::Class, object)
    end

    const_set(:Class, ::Module.new do
      extend Checker::Protocol

      def self.__kind; ::Class; end

      def self.class?(value); Kind.of_class?(value); end

      def self.__is_instance__(value); class?(value); end
    end)

    def self.Class?(*args)
      ::Kind::Deprecation.warn_method_replacement('Kind::Of::Class?', 'Kind::Class?')

      Kind::Class?(*args)
    end

    # -- Module

    def self.Module(object = Undefined)
      ::Kind::Deprecation.warn_method_replacement('Kind::Of::Module', 'Kind::Module')

      return Module if Undefined == object

      self.call(::Module, object)
    end

    const_set(:Module, ::Module.new do
      extend Checker::Protocol

      def self.__kind_undefined(value)
        __kind_error(Kind::Undefined) if Kind::Undefined == value

        yield
      end

      def self.__kind_error(value)
        raise Kind::Error.new('Module'.freeze, value)
      end

      def self.__kind_of(value)
        return value if Kind.of_module?(value)

        __kind_error(value)
      end

      def self.__kind; ::Module; end

      def self.class?(value); Kind.of_module?(value); end

      def self.instance(value, options = Empty::HASH)
        default = options[:or]

        if ::Kind::Maybe::Value.none?(default)
          __kind_undefined(value) { __kind_of(value) }
        else
          return value if Kind::Undefined != value && instance?(value)

          __kind_undefined(default) { __kind_of(default) }
        end
      end

      def self.__is_instance__(value); class?(value); end
    end)

    def self.Module?(*args)
      ::Kind::Deprecation.warn_method_replacement('Kind::Of::Module?', 'Kind::Module?')

      Kind::Module?(*args)
    end

    # -- Boolean

    def self.Boolean(object = Undefined, options = Empty::HASH)
      ::Kind::Deprecation.warn_method_replacement('Kind::Of::Boolean', 'Kind::Boolean')

      default = options[:or]

      return Kind::Of::Boolean if Undefined == object && default.nil?

      bool = object.nil? ? default : object

      return bool if bool.is_a?(::TrueClass) || bool.is_a?(::FalseClass)

      raise Kind::Error.new('Boolean'.freeze, bool)
    end

    const_set(:Boolean, ::Module.new do
      extend Checker::Protocol

      def self.__kind; [TrueClass, FalseClass].freeze; end

      def self.class?(value); Kind.is.Boolean(value); end

      def self.instance(value, options= Empty::HASH)
        default = options[:or]

        if ::Kind::Maybe::Value.none?(default)
          __kind_undefined(value) { Kind::Of::Boolean(value) }
        else
          return value if Kind::Undefined != value && instance?(value)

          __kind_undefined(default) { Kind::Of::Boolean(default) }
        end
      end

      def self.__kind_undefined(value)
        if Kind::Undefined == value
          raise Kind::Error.new('Boolean'.freeze, Kind::Undefined)
        else
          yield
        end
      end

      def self.__is_instance__(value);
        value.is_a?(TrueClass) || value.is_a?(FalseClass)
      end

      def self.or_undefined(value)
        result = or_nil(value)
        result.nil? ? Kind::Undefined : result
      end
    end)

    def self.Boolean?(*args)
      ::Kind::Deprecation.warn_method_replacement('Kind::Of::Boolean?', 'Kind::Boolean?')

      Kind::Boolean?(*args)
    end

    # -- Lambda

    def self.Lambda(object = Undefined, options = Empty::HASH)
      ::Kind::Deprecation.warn_method_replacement('Kind::Of::Lambda', 'Kind::Lambda')

      default = options[:or]

      return Kind::Of::Lambda if Undefined == object && default.nil?

      func = object || default

      return func if func.is_a?(::Proc) && func.lambda?

      raise Kind::Error.new('Lambda'.freeze, func)
    end

    const_set(:Lambda, ::Module.new do
      extend Checker::Protocol

      def self.__kind; ::Proc; end

      def self.instance(value, options = Empty::HASH)
        default = options[:or]

        if ::Kind::Maybe::Value.none?(default)
          __kind_undefined(value) { Kind::Of::Lambda(value) }
        else
          return value if Kind::Undefined != value && instance?(value)

          __kind_undefined(default) { Kind::Of::Lambda(default) }
        end
      end

      def self.__kind_undefined(value)
        if Kind::Undefined == value
          raise Kind::Error.new('Lambda'.freeze, Kind::Undefined)
        else
          yield
        end
      end

      def self.__is_instance__(value)
        value.is_a?(__kind) && value.lambda?
      end
    end)

    def self.Lambda?(*args)
      ::Kind::Deprecation.warn_method_replacement('Kind::Of::Lambda?', 'Kind::Lambda?')

      Kind::Lambda?(*args)
    end

    # -- Callable

    def self.Callable(object = Undefined, options = Empty::HASH)
      ::Kind::Deprecation.warn_method_replacement('Kind::Of::Callable', 'Kind::Callable')

      default = options[:or]

      return Kind::Of::Callable if Undefined == object && default.nil?

      callable = object || default

      return callable if callable.respond_to?(:call)

      raise Kind::Error.new('Callable'.freeze, callable)
    end

    const_set(:Callable, ::Module.new do
      extend Checker::Protocol

      def self.__kind; Object; end

      def self.class?(value)
        Kind::Is::Callable(value)
      end

      def self.instance(value, options = Empty::HASH)
        default = options[:or]

        if ::Kind::Maybe::Value.none?(default)
          __kind_undefined(value) { Kind::Of::Callable(value) }
        else
          return value if Kind::Undefined != value && instance?(value)

          __kind_undefined(default) { Kind::Of::Callable(default) }
        end
      end

      def self.__kind_undefined(value)
        if Kind::Undefined == value
          raise Kind::Error.new('Callable'.freeze, Kind::Undefined)
        else
          yield
        end
      end

      def self.__is_instance__(value);
        value.respond_to?(:call)
      end
    end)

    def self.Callable?(*args)
      ::Kind::Deprecation.warn_method_replacement('Kind::Of::Callable?', 'Kind::Callable?')

      Kind::Of::Callable.instance?(*args)
    end
  end
end
