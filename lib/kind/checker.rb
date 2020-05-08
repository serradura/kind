# frozen_string_literal: true

module Kind
  module Checkable
    def class?(value)
      Kind::Is.__call__(__kind, value)
    end

    def instance(value, options = Empty::HASH)
      default = options[:or]

      return Kind::Of.(__kind, value) if ::Kind::Maybe::Value.none?(default)

      value != Kind::Undefined && instance?(value) ? value : Kind::Of.(__kind, default)
    end

    def [](value, options = options = Empty::HASH)
      instance(value, options)
    end

    def instance?(*args)
      return to_proc if args.empty?

      return args.all? { |object| __is_instance__(object) } if args.size > 1

      arg = args[0]
      arg == Kind::Undefined ? to_proc : __is_instance__(arg)
    end

    def __is_instance__(value)
      value.is_a?(__kind)
    end

    def to_proc
      @to_proc ||=
        -> checker { -> value { checker.__is_instance__(value) } }.call(self)
    end

    def or_nil(value)
      return value if instance?(value)
    end

    def or_undefined(value)
      or_nil(value) || Kind::Undefined
    end

    def as_maybe(value = Kind::Undefined)
      return __as_maybe__(value) if value != Kind::Undefined

      as_maybe_to_proc
    end

    def as_optional(value = Kind::Undefined)
      as_maybe(value)
    end

    def __as_maybe__(value)
      Kind::Maybe.new(or_nil(value))
    end

    def as_maybe_to_proc
      @as_maybe_to_proc ||=
        -> checker { -> value { checker.__as_maybe__(value) } }.call(self)
    end
  end

  private_constant :Checkable

  class Checker
    include Checkable

    attr_reader :__kind

    def initialize(kind)
      @__kind = kind
    end
  end
end
