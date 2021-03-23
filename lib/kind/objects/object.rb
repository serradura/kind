# frozen_string_literal: true

require 'kind/maybe'

module Kind
  module Object
    include Kind::BasicObject
    include Maybe::Buildable
    include UnionType::Buildable

    def name
      kind.name
    end

    def ===(value)
      kind === value
    end

    def inspect
      "Kind::Object<#{name}>"
    end
  end

  class Object::Instance # :nodoc: all
    include ::Kind::Object

    ResolveKindName = ->(kind, opt) do
      name = Try.call!(opt, :[], :name)
      name || Try.call!(kind, :name)
    end

    attr_reader :kind, :name

    def initialize(kind, opt)
      name = ResolveKindName.(kind, opt)

      @name = STRICT.kind_of(::String, name)
      @kind = KIND.respond_to!(:===, kind)
    end

    private_constant :ResolveKindName
  end

  # Kind[]
  def self.[](kind, opt = Empty::HASH)
    Object::Instance.new(kind, opt)
  end

  # Kind::Of()
  def self.Of(*args)
    warn '[DEPRECATION] Kind::Of() is deprecated; use Kind[] instead. ' \
        'It will be removed on next major release.'

    self[*args]
  end
end
