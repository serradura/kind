# frozen_string_literal: true

module Kind
  class RespondTo
    def self.[](*args)
      args.each { |arg| KIND.of!(::Symbol, arg) }

      new(args)
    end

    private_class_method :new

    def initialize(method_names)
      @method_names = method_names
    end

    def |(another_kind)
      UnionType[self] | another_kind
    end

    def ===(value)
      KIND.interface?(@method_names, value)
    end

    alias_method :call, :===

    def [](value)
      KIND.of!(self, value)
    end

    def inspect
      @inspect ||= "Kind::RespondTo#{@method_names}"
    end

    alias_method :name, :inspect
  end
end
