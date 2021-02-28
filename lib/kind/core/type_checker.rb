# frozen_string_literal: true

module Kind
  module TypeChecker
    def name
      kind.name
    end

    def ===(value)
      kind === value
    end

    def [](value)
      return value if self === value

      KIND.error!(name, value)
    end

    def or_nil(value)
      return value if self === value
    end

    def or_undefined(value)
      or_nil(value) || Undefined
    end

    def or(fallback, value = UNDEFINED)
      return __or_func.(fallback) if UNDEFINED === value

      self === value ? value : fallback
    end

    def value?(value = UNDEFINED)
      return self === value if UNDEFINED != value

      @__is_value ||= ->(tc) { ->(arg) { tc === arg } }.(self)
    end

    def value(arg, default:)
      KIND.value(self, arg, self[default])
    end

    def or_null(value) # :nodoc:
      KIND.null?(value) ? value : self[value]
    end

    def maybe(value = UNDEFINED, &block)
      return __maybe[value] if UNDEFINED != value && !block
      return __maybe.wrap(&block) if UNDEFINED == value && block
      return __maybe.wrap(value, &block) if UNDEFINED != value && block

      __maybe
    end

    alias optional maybe

    private

      def __maybe
        @__maybe ||= Maybe::Typed.new(self)
      end

      def __or_func
        @__or_func ||= ->(tc, fb, value) { tc === value ? value : tc.or_null(fb) }.curry[self]
      end
  end

  class TypeChecker::Object # :nodoc: all
    include TypeChecker

    ResolveKindName = ->(kind, opt) do
      name = Try.(opt, :[], :name)
      name || Try.(kind, :name)
    end

    attr_reader :kind, :name

    def initialize(kind, opt)
      name = ResolveKindName.(kind, opt)

      @name = KIND.of!(::String, name)
      @kind = KIND.respond_to!(:===, kind)
    end

    private_constant :ResolveKindName
  end
end