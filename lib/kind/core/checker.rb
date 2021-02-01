# frozen_string_literal: true

module Kind
  module Core::Checker
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

      Core::Utils.kind_error!(name, value)
    end

    def null_or_instance(value) # :nodoc:
      Core::Utils.null?(value) ? value : self[value]
    end

    private

      def __or_func
        @__or_func ||= ->(ck) {
          ->(fb) {->(value) { ck.instance?(value) ? value : ck.null_or_instance(fb) } }
        }.(self)
      end
  end

  class Core::Checker::Object # :nodoc: all
    include Core::Checker

    MapArgsFromHash = ->(arg) do
      kind = arg.fetch(:kind)

      [kind, arg.fetch(:name, Kind::Try.(kind, :name))]
    end

    MapKindAndName = ->(kind, arg) do
      name = Kind::Try.(arg || ::Kind::Empty::HASH, :[], :name)

      [kind, name || Kind::Try.(kind, :name)]
    end

    ResolveArgs = ->(arg1, arg2) do
      return MapArgsFromHash[arg1] if arg1.kind_of?(::Hash)
      return MapKindAndName[arg1, arg2] if arg1.respond_to?(:===)
    end

    attr_reader :kind, :name

    def initialize(args)
      arg1, arg2 = ResolveArgs[args[0], args[1]]

      @kind = Core::Utils.kind_respond_to!(:===, arg1)
      @name = Core::Utils::kind_of!(::String, arg2)
    end

    private_constant :MapArgsFromHash, :MapKindAndName, :ResolveArgs
  end
end
