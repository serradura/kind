# frozen_string_literal: true

module Kind
  module TypeChecker
    def name
      kind.name
    end

    def ===(value)
      kind === value
    end

    def instance?(value = Undefined)
      return self === value if Undefined != value

      @__instance_func ||= ->(ck) { ->(value) { ck === value } }.(self)
    end

    def or_nil(value)
      return value if instance?(value)
    end

    def or_undefined(value)
      or_nil(value) || Undefined
    end

    def or(fallback, value = Undefined)
      return __or_func.(fallback) if Undefined === value

      instance?(value) ? value : fallback
    end

    def [](value)
      return value if instance?(value)

      KIND.error!(name, value)
    end

    def null_or_instance(value) # :nodoc:
      KIND.null?(value) ? value : self[value]
    end

    private

      def __or_func
        @__or_func ||= ->(ck) {
          ->(fb) {->(value) { ck.instance?(value) ? value : ck.null_or_instance(fb) } }
        }.(self)
      end
  end

  class TypeChecker::Object # :nodoc: all
    include TypeChecker

    ResolveKindName = ->(kind, opt) do
      name = Kind::Try.(opt, :[], :name)
      name || Kind::Try.(kind, :name)
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
