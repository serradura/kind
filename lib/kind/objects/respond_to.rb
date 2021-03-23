# frozen_string_literal: true

module Kind
  class RespondTo
    include Kind::BasicObject

    def self.[](*args)
      args.each { |arg| STRICT.kind_of(::Symbol, arg) }

      new(args)
    end

    private_class_method :new

    attr_reader :inspect

    def initialize(method_names)
      @method_names = method_names
      @inspect = "Kind::RespondTo#{@method_names}"
    end

    def ===(value)
      KIND.interface?(@method_names, value)
    end

    alias_method :call, :===

    alias_method :name, :inspect
  end
end
