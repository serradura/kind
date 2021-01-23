# frozen_string_literal: true

module Kind
  class Checker
    module Protocol
      def class?(value)
        Core::Utils.is?(__kind, value)
      end

      def instance(value, options = Empty::HASH)
        default = options[:or]

        return Core::Utils.kind_of!(__kind, value) if ::Kind::Maybe::Value.none?(default)

        Kind::Undefined != value && instance?(value) ? value : Core::Utils.kind_of!(__kind, default)
      end

      def [](value, options = options = Empty::HASH)
        instance(value, options)
      end

      def to_proc
        @to_proc ||=
          -> checker { -> value { checker.instance(value) } }.call(self)
      end

      def __is_instance__(value)
        value.kind_of?(__kind)
      end

      def is_instance_to_proc
        @is_instance_to_proc ||=
          -> checker { -> value { checker.__is_instance__(value) } }.call(self)
      end

      def instance?(*args)
        return is_instance_to_proc if args.empty?

        return args.all? { |object| __is_instance__(object) } if args.size > 1

        arg = args[0]
        Kind::Undefined == arg ? is_instance_to_proc : __is_instance__(arg)
      end

      def or_nil(value)
        return value if instance?(value)
      end

      def or_undefined(value)
        or_nil(value) || Kind::Undefined
      end

      def __as_maybe__(value)
        Kind::Maybe.new(or_nil(value))
      end

      def as_maybe_to_proc
        @as_maybe_to_proc ||=
          -> checker { -> value { checker.__as_maybe__(value) } }.call(self)
      end

      def as_maybe(value = Kind::Undefined)
        return __as_maybe__(value) if Kind::Undefined != value

        as_maybe_to_proc
      end

      def as_optional(value = Kind::Undefined)
        as_maybe(value)
      end
    end
  end
end
